/**
* @Author Incapsulate
* @Since 12-03-2019
* @Description: 
*/
public class RepeaterController {
        
   /* @AuraEnabled
    public static List<RepeaterComponentWrapper> getComponentsByGroupNameNew(String groupName) {
        List<RepeaterComponentWrapper> wrappedComponentsNew = new List<RepeaterComponentWrapper>();
        Set<Id> elementIds = new Set<Id>();
            for (Form__c record : [SELECT 
                                            (Select Element__c, Form__c From Form_Elements__r)
                                            FROM Form__c
                                           	WHERE Name = :groupName])
            {
                for (Form_Element__c child : record.Form_Elements__r)
                {
                    elementIds.add(child.Element__c);
                }
            }
        //Lightning_Element__r.name instead of this use new field Lightning_Element_Name__c
        //Lightning_Attribute__r.name instead of this use new field Lightning_Attribute_Name__c
            for (Element__c record : [Select Lightning_Component_Name__c , (Select Lightning_Element__r.name From Elements__r),
             							(Select Lightning_Attribute_Name__c ,Value__c From Element_Attributes__r) 
             							From Element__c where id in :elementIds])
            {
                Map<String, Object> attributes = new Map<String, Object>();
                for (Element_Attribute__c child : record.Element_Attributes__r)
                {	
                    if(String.isNotEmpty(child.Value__c)){
                    	putAttribute(attributes, child.Lightning_Attribute_Name__c, 'String', child.Value__c);
                    }                    
                }                
                RepeaterComponentWrapper.RepeaterCard rc = new RepeaterComponentWrapper.RepeaterCard();
                rc.name = record.Lightning_Component_Name__c;                
                wrappedComponentsNew.add(new RepeaterComponentWrapper(rc, attributes));                
            }
            
        return wrappedComponentsNew;
    }*/
    
     /**
    * @Author Incapsulate
    * @Since 06-05-2019
    * @Description: 
    */
    @AuraEnabled
    public static List<RepeaterComponentWrapper> getComponentsByGroupNameCustomMetadata(String groupName) {
        List<RepeaterComponentWrapper> rcw = null;
        //below service will be using the custom metadata information without datamodel
        rcw = FormElementInfoService.getComponentsByGroupNameCustomMetadata(groupName);
        //Note: below code is temporary here we are checking first in metadata tables whether the
        //repeater card details are exist or not if not we fetch the details from the datamodel.
        //below code will full fill the existing flow where we are working on datamodel and custom metadata records.
        if(rcw != null && rcw.size()>0){
            rcw =rcw;
        }else{
            rcw = FormElementInfoService.getComponentsByGroupNameNew(groupName);
        }
        
        return rcw;
    }
    
    /**
    * @Author Incapsulate
    * @Since 12-03-2019
    * @Description: 
    */
    @AuraEnabled
    public static List<RepeaterComponentWrapper> getComponentsByGroupName(String groupName) {
        //return FormElementInfoService.getRepeaterComponentsByGroupNameOld(groupName);
        //below service will be using the custom metadata information
        return FormElementInfoService.getComponentsByGroupNameNew(groupName);
    }
    
    /**
    * @Author Incapsulate
    * @Since 02-04-2019
    * @Description: This method deletes record
    */
    @AuraEnabled
    public static void deleteRecord(Id recordId , String ObjectType){
        string query = 'SELECT Id FROM '+ObjectType+' WHERE Id='+'\''+recordId+'\'';
        delete Database.query(query);
    }
   /* private static void putAttribute(Map<String, Object> attributes, String attrName, String attrType, String attrValue) {
        if(String.isNotBlank(attrName)) {
            Object value = null;
            try{
                switch on attrType {
                    when 'Number' { value = JSON.deserializeUntyped(attrValue); }
                    when 'Checkbox' { value = JSON.deserializeUntyped(attrValue); }
                    when 'JSON' { value = JSON.deserializeUntyped(attrValue); }
                    when else { value = attrValue; }
                }
            }
            catch(Exception ex) {
                System.debug('Unable to get value for attribute: ' + attrName);
            }
            attributes.put(attrName, value);
        }
    }
    
    @AuraEnabled
    public static List<SObject> getRecords(String objectType, String recordTypeId, String parentId, String parentField, List<String> fields){
        if(String.isBlank(objectType) || fields.isEmpty()) {
            return new List<SObject>();
        }

        String query = 'SELECT ';
        query += JSON.serialize(new Set<String>(fields)).replaceAll('["\\[\\]]', '');
        query += ' FROM ' + objectType;
        List<String> filters = new List<String>();
        if(String.isNotBlank(parentId) && String.isNotBlank(parentField)) {
            filters.add(parentField + '=\'' + parentId + '\'');
        }
        if(String.isNotBlank(recordTypeId)) {
            filters.add('RecordTypeId=\'' + recordTypeId + '\'');
        }
        if(!filters.isEmpty()) {
            query += ' WHERE ' + JSON.serialize(filters).replaceAll('["\\[\\]]', '').replace(',', ' AND ');
        }
        return Database.query(query);
    }

    @AuraEnabled
    public static void saveRecords(List<SObject> savedRecords, List<SObject> deletedRecords) {
        upsert savedRecords;
        delete deletedRecords;
    }*/

}