/**
* @Author Incapsulate
* @Since 17-06-2019
* @Description: 
*/
public class DynamicGenericReadOnlyController {
    /**
    * @Author Incapsulate
    * @Since 17-06-2019
    * @Description: 
    */
	@AuraEnabled
    public static List<GenericRequestResponse> getDynamicResponsne(GenericRequestResponse grr) {
        List<GenericRequestResponse> grrList = new List<GenericRequestResponse>();
        DynamicGenericReadOnlyController.getFromSobject(grr);
        return grrList;
    }
    
    /**
    * @Author Incapsulate
    * @Since 17-06-2019
    * @Description: 
    */
    public static List<GenericRequestResponse> getFromSobject(GenericRequestResponse grr){
        	List<GenericRequestResponse> grrList = new List<GenericRequestResponse>();
            String queryString = 'select ID,'+grr.requestColName+' from '+grr.sobjectApiName +' where '+grr.filterColName +' = :'+grr.filterColValue;
            SObject[] queryParentObject = Database.query(queryString);
            for (SObject parentRecord : queryParentObject){ 
                GenericRequestResponse grrnew = new GenericRequestResponse();
                Map<string, string> newOptions = new Map<string, string>{};
                Object parentFieldValue = parentRecord.get(grr.requestColName); 
                String value = (String)parentFieldValue;
                grrnew.requestColName = value;
                grrList.add(grrnew);
            }
        return grrList;
    }
    
    public class GenericRequestResponse{
        @AuraEnabled
        public String filterColName;
        @AuraEnabled
        public String filterColValue;
        @AuraEnabled
        public String requestColName;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String sobjectApiName;
    }
}