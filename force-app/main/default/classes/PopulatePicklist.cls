/**
* @Author Incapsulate
* @Since 02-05-2019
* @Description: 
*/
global with sharing class PopulatePicklist {
    
private static final String UI_API = '/services/data/v43.0/ui-api/object-info/{0}/picklist-values/{1}/{2}';
    
    /**
    * @Author Incapsulate
    * @Since 02-05-2019
    * @Description: 
    */
    @AuraEnabled
    global static list<Map<string, string> > getPicklistValues(string obj, String fld,String recordTypeDeveloperName){
        list<Map<string, string> > options = new list<Map<string, string> >();
        checkAccess(obj, new string[]{fld}, 'read');    
        options = PopulatePicklistService.getPicklistValueByRecordType(obj,fld,recordTypeDeveloperName,options);
        return options;
    }
    @AuraEnabled
    global static list<Map<string, string> > getPicklistFromSobjectValues(string obj, String fld,String recordTypeDeveloperName){
        list<Map<string, string> > options = new list<Map<string, string> >();
        checkAccess(obj, new string[]{fld}, 'read');    
        //options = PopulatePicklistService.getPicklistValueByRecordType(obj,fld,recordTypeDeveloperName,options);
         options = PopulatePicklistService.getFromSobject(fld, obj,options);
        return options;
    }
    private static void checkAccess(string sobjectName, String[] fields, string accessType){
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