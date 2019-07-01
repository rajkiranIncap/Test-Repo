/**
* @Author Incapsulate
* @Since 21-06-2019
* @Description: class for repeaterILALite
*/
public class DynamicControllerILALite {
    @AuraEnabled
    public static List<DynamicComponentWrapper> getComponentsByGroupName(String groupName) {
        List<Repeater_Component__mdt> components = [
            SELECT Id, Group_Name__c, Display_Rank__c, Component_Name__c,Component_Type__c,
            Attribute_1_Name__c, Attribute_1_Type__c, Attribute_1_Value__c,
            Attribute_2_Name__c, Attribute_2_Type__c, Attribute_2_Value__c,
            Attribute_3_Name__c, Attribute_3_Type__c, Attribute_3_Value__c,
            Attribute_4_Name__c, Attribute_4_Type__c, Attribute_4_Value__c,
            Attribute_5_Name__c, Attribute_5_Type__c, Attribute_5_Value__c,
            Attribute_6_Name__c, Attribute_6_Type__c, Attribute_6_Value__c,
            Attribute_7_Name__c, Attribute_7_Type__c, Attribute_7_Value__c,
            Attribute_8_Name__c, Attribute_8_Type__c, Attribute_8_Value__c,
            Attribute_9_Name__c, Attribute_9_Type__c, Attribute_9_Value__c,
            Attribute_10_Name__c, Attribute_10_Type__c, Attribute_10_Value__c
            FROM Repeater_Component__mdt
            WHERE Group_Name__c = :groupName
            ORDER BY Display_Rank__c ASC
        ];
        
        List<DynamicComponentWrapper> wrappedComponents = new List<DynamicComponentWrapper>();
        for(Repeater_Component__mdt cmp : components) {
            cmp.Component_Name__c = cmp.Component_Name__c;
            Map<String, Object> attributes = new Map<String, Object>();
            putAttribute(attributes, cmp.Attribute_1_Name__c, cmp.Attribute_1_Type__c, cmp.Attribute_1_Value__c);
            putAttribute(attributes, cmp.Attribute_2_Name__c, cmp.Attribute_2_Type__c, cmp.Attribute_2_Value__c);
            putAttribute(attributes, cmp.Attribute_3_Name__c, cmp.Attribute_3_Type__c, cmp.Attribute_3_Value__c);
            putAttribute(attributes, cmp.Attribute_4_Name__c, cmp.Attribute_4_Type__c, cmp.Attribute_4_Value__c);
            putAttribute(attributes, cmp.Attribute_5_Name__c, cmp.Attribute_5_Type__c, cmp.Attribute_5_Value__c);
            putAttribute(attributes, cmp.Attribute_6_Name__c, cmp.Attribute_6_Type__c, cmp.Attribute_6_Value__c);
            putAttribute(attributes, cmp.Attribute_7_Name__c, cmp.Attribute_7_Type__c, cmp.Attribute_7_Value__c);
            putAttribute(attributes, cmp.Attribute_8_Name__c, cmp.Attribute_8_Type__c, cmp.Attribute_8_Value__c);
            putAttribute(attributes, cmp.Attribute_9_Name__c, cmp.Attribute_9_Type__c, cmp.Attribute_9_Value__c);
            putAttribute(attributes, cmp.Attribute_10_Name__c, cmp.Attribute_10_Type__c, cmp.Attribute_10_Value__c);
            if(String.isNotBlank(cmp.Component_Type__c)){
            	putAttribute(attributes, 'type', 'String', cmp.Component_Type__c);
            }
            wrappedComponents.add(new DynamicComponentWrapper(cmp, attributes));
        }
        
        return wrappedComponents;
    }
    
    private static void putAttribute(Map<String, Object> attributes, String attrName, String attrType, String attrValue) {
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
    
    public class DynamicComponentWrapper {
        @AuraEnabled
        public Repeater_Component__mdt component;
        
        @AuraEnabled
        public Map<String, Object> attributes;
        
        public DynamicComponentWrapper(Repeater_Component__mdt component, Map<String, Object> attributes) {
            this.component = component;
            this.attributes = attributes;
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
    }
    
}