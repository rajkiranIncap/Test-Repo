public class PopulateMultiSelectPicklist {

    /**
    * @Author Incapsulate
    * @Since 02-05-2019
    * @Description: 
    */
    @AuraEnabled
    public static list<Map<string, string> > getPicklistValues(string obj, String fld){
        list<Map<string, string> > options = new list<Map<string, string> >();
        PopulatePicklistService.checkAccess(obj, new string[]{fld}, 'read');    
        options = PopulatePicklistService.getPicklistValueByRecordType(obj,fld,null,options);
        return options;
    }
    
}