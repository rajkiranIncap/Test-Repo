/**
  * @author Incapsulate
  * @description Class used for creating DependentPicklist.
*/
public with sharing class DependentPicklistController {
    public DependentPicklistController() {

    }

    @AuraEnabled
    public static List<String> getSelectOptions(string objectName, string fld) {

      List <String> allOpts = new list <String>();
      // Get the object type 
      Schema.sObjectType objType = Schema.getGlobalDescribe().get(objectName);
     
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
      // Get a map of fields for the SObject
      map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
      // Get the list of picklist values for this field.
      list < Schema.PicklistEntry > values =
       fieldMap.get(fld).getDescribe().getPickListValues();
     
      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a: values) {
       allOpts.add(a.getValue());
      }

      //allOpts.sort();
      return allOpts;
     }
    
    
    
   
    /**
    * @Author Incapsulate
    * @Since 22-05-2019
    * @Description: if dependent picklist comes from the sobject data 
        Ex. controlling field sobject API controllingSobjectAPI=country__c, depedent list comes from dependentSobjectAPI=state__c, 
                                 controllingSobjectFieldAPI=Name,dependentSobjectFieldAPI=Name 
    */
    @AuraEnabled 
    public static Map<String,List<PicklistEntryWrapper>> getDependentMapFromSobjectOrDependentpicklist(Boolean isDepedentBasedOnSobjects,
                                                                                                     string objectName,string contrfieldApiName,string depfieldApiName,
                                                                                                     String controllingSobjectAPI,
                                                                                                     String dependentSobjectAPI
                                                                                                     ) {
        Map<String,List<PicklistEntryWrapper>> objPicklistResults = new Map<String,List<PicklistEntryWrapper>>();
                                                                                                                 
        if(!isDepedentBasedOnSobjects){
            objPicklistResults = getDependentMap(objectName,contrfieldApiName,depfieldApiName);
        }else{
            String queryString = 'select ID,'+contrfieldApiName+',(select id,'+depfieldApiName+' from '+dependentSobjectAPI+') from '+controllingSobjectAPI;
            SObject[] queryParentObject = Database.query(queryString);
                     
            for (SObject parentRecord : queryParentObject){ 
                Object parentFieldValue = parentRecord.get(contrfieldApiName); 
                String label = (String)parentFieldValue;
                List<PicklistEntryWrapper> objectlst = new List<PicklistEntryWrapper>();
                // Prevent a null relationship from being accessed
                SObject[] childRecordsFromParent = parentRecord.getSObjects(dependentSobjectAPI);
                if (childRecordsFromParent != null) {
                    for (SObject childRecord : childRecordsFromParent){ 
                        Object childFieldValue = childRecord.get(depfieldApiName); 
                        PicklistEntryWrapper pe = new PicklistEntryWrapper();
                        pe.label = (String)childFieldValue;
                        pe.value = (String)childFieldValue;
                        objectlst.add(pe);
                    }
                    objPicklistResults.put(label, objectlst);
                }              
            }

            // test code need to remove 
            // below code is working as expected need to implement the flag and utilize the same
            /*objPicklistResults = new Map<String,List<PicklistEntryWrapper>>();
            List<country__c> iclst = [select ID,name,(select id,name from States__r) from country__c];
            for(country__c ic : iclst){
                String label = ic.name;
                List<PicklistEntryWrapper> objectlst = new List<PicklistEntryWrapper>();
                for(State__c c: ic.States__r){
                    PicklistEntryWrapper pe = new PicklistEntryWrapper();
                    pe.label = c.name;
                    pe.value = c.name;
                    objectlst.add(pe);
                }
                objPicklistResults.put(label, objectlst);
            }
            System.debug('>>>>'+objPicklistResults);*/
        }
        return objPicklistResults;
    }
     //below code is to fetch the dependent picklist map
    @AuraEnabled 
    public static Map<String,List<PicklistEntryWrapper>> getDependentMap(string objectName,string contrfieldApiName,string depfieldApiName) {
         
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        Map<String,List<PicklistEntryWrapper>> objPicklistResults = new Map<String,List<PicklistEntryWrapper>>();
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = Schema.getGlobalDescribe().get(objectName);//objDetail.getSObjectType();
        if (objType==null){
            return objPicklistResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objPicklistResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            objPicklistResults.put(label, new List<PicklistEntryWrapper>());
            controllingValues.add(label);
            
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                    objPicklistResults.get(controllingValues.get(i)).add(plew);
                }
            }
        }
       
        // test code need to remove 
        // below code is working as expected need to implement the flag and utilize the same
       /* objPicklistResults = new Map<String,List<PicklistEntryWrapper>>();
        List<country__c> iclst = [select ID,name,(select id,name from States__r) from country__c];
            for(country__c ic : iclst){
                String label = ic.name;
                List<PicklistEntryWrapper> objectlst = new List<PicklistEntryWrapper>();
                for(State__c c: ic.States__r){
                    PicklistEntryWrapper pe = new PicklistEntryWrapper();
                    pe.label = c.name;
                    pe.value = c.name;
                    objectlst.add(pe);
                }
                objPicklistResults.put(label, objectlst);
            }
        System.debug('>>>>'+objPicklistResults);*/
        return objPicklistResults;
    }
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }

    /*private static sObject getSobject(string contrfieldApiName,string depfieldApiName,String controllingSobjectAPI,String dependentSobjectAPI){
        Type theClass = Type.forName(ObjectName);
            sObject objInstance = (SObject)JSON.deserialize(jsonSobject,theClass);
        return objInstance;
    }   */ 
    private static List<sObject> getListOfSobject(string contrfieldApiName,string depfieldApiName,String controllingSobjectAPI,String dependentSobjectAPI){
            
        String str = 'select ID,'+contrfieldApiName+',(select id,'+depfieldApiName+' from '+dependentSobjectAPI+') from '+controllingSobjectAPI;
        List<sObject> sobjList = Database.query(str);
        
        /*String jsonAttribute = JSON.serialize(jsonMap.get('attributes'));
            Attributes att  = (Attributes) JSON.deserialize(jsonAttribute,Attributes.class);
            String objectName = att.type;
            Type theClass = Type.forName(ObjectName);
            sObject objInstance = (SObject)JSON.deserialize(jsonSobject,theClass);*/
        return sobjList;
    }
}