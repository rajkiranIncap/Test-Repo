/**
* @Author Incapsulate
* @Since 02-05-2019
* @Description: 
*/
public class PopulatePicklistService {
    
    private static final String UI_API = '/services/data/v43.0/ui-api/object-info/{0}/picklist-values/{1}/{2}';
    
    /**
    * @Author Incapsulate
    * @Since 05-06-2019
    * @Description: 
    */
    public static List<Map<string, string> > getFromSobject(String contrfieldApiName, String controllingSobjectAPI,List<Map<string, string> > options){
        
            String queryString = 'select ID,'+contrfieldApiName+' from '+controllingSobjectAPI;
            SObject[] queryParentObject = Database.query(queryString);
            
            for (SObject parentRecord : queryParentObject){ 
                Map<string, string> newOptions = new Map<string, string>{};
                Object parentFieldValue = parentRecord.get(contrfieldApiName); 
                String label = (String)parentFieldValue;
                newOptions.put('value', label);
                newOptions.put('label', label);
                options.add(newOptions);                
                           
            }
        return options;
    }
    /**
    * @Author Incapsulate
    * @Since 02-05-2019
    * @Description: 
    */
     public static List<Map<string, string> > getPicklistValueByRecordType(String objectAPIName, String fieldAPIName, String recordTypeDeveloperName,List<Map<string, string> > options){
           //get record type Id
           List<RecordType> recordTypes = [Select Id, Name From RecordType  Where SobjectType = :objectAPIName and DeveloperName = :recordTypeDeveloperName limit 1];
           Id recordTypeId = (!recordTypes.isEmpty()) ? recordTypes.get(0).Id : null;       
           if((Test.isRunningTest() && String.isEmpty(recordTypeDeveloperName)) || (!Test.isRunningTest() && String.isEmpty(recordTypeId))){
               Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectAPIName);
                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
                list<Schema.PicklistEntry> values =
                    fieldMap.get(fieldAPIName).getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : values)
                {
                    Map<string, string> newOptions = new Map<string, string>{};
                    newOptions.put('value', a.getValue());
                    newOptions.put('label', a.getLabel());
                    options.add(newOptions);
                }
           }else{
               try{
                   HTTPResponse response = getPicklistValuesFromExternalService(objectAPIName, recordTypeId, fieldAPIName );
                   if(response.getStatusCode() == 200){
                       Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                       if(root.containsKey('values')){ 
                           List<Object> picklistVals = (List<Object>)root.get('values');
                           for(Object picklistVal : picklistVals){
                               Map<String,Object> picklistValMap = (Map<String,Object>) picklistVal;
                               Map<string, string> newOptions = new Map<string, string>{};
                               newOptions.put('value', (String) picklistValMap.get('value'));
                               newOptions.put('label', (String) picklistValMap.get('label'));
                               options.add(newOptions);
                           }
                       }               
                   }
               }catch(Exception ex){
                    AuraHandledException e = new AuraHandledException('Error occured while fetching the picklist values: ');
                    e.setMessage('Error occured while fetching the picklist values:');
                    throw e;
               }
           }
         
       return options;
   }
    
    /**
    * @Author Incapsulate
    * @Since 02-05-2019
    * @Description: 
    */
    public static HttpResponse getPicklistValuesFromExternalService(String objectAPIName, String fieldAPIName, String recordTypeId) {
        String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();                   
        String url = String.format(UI_API, new String[]{ objectAPIName, recordTypeId, fieldAPIName });           
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        req.setEndpoint(salesforceHost+url);
        req.setHeader('Content-type', 'application/json');
        String sessionId = UserInfo.getSessionId(); 
        String autho ='Bearer '+ sessionId;
        req.setHeader('Authorization', autho);
        Http http = new Http();
        HTTPResponse response = http.send(req);
        return response;
    }
    
     public static void checkAccess(string sobjectName, String[] fields, string accessType){
        SObjectType sobj = Schema.getGlobalDescribe().get(sobjectName);
        Map<String,Schema.SObjectField> sobjectfields = sobj.getDescribe().fields.getMap();
        String[] systemFields = new String[] {
            'Id',
            'IsDeleted',
            'CreatedBy',
            'CreatedById',
            'CreatedDate',
            'LastModifiedBy',
            'LastModifiedById',
            'LastModifiedDate',
            'SystemModstamp'
        };
        if(accessType == 'read') {
            for (String field : fields) {
                if (!sobjectfields.get(field).getDescribe().isAccessible()) {
                    AuraHandledException e = new AuraHandledException('Access to one or more necessary fields is restricted for the current user.');
                    e.setMessage('Access to one or more necessary fields is restricted for the current user.');
                    throw e;
    
                }
            }
        } 
    }
}