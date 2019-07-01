/**
* @Author Incapsulate
* @Since 08-05-2019
* @Description: The class is used to fetch the details of data grid based on custom metadata defined in the system. 
*/
public class FormTableController {
   /**
    * @Author Incapsulate
    * @Since 08-03-2019
    * @Description: This method is used to fetch the
    */
    @AuraEnabled
    public static List<RepeaterComponentWrapper> getComponentsByGroupNameNew(String groupName) {
        
        List<RepeaterComponentWrapper> wrappedComponents = new List<RepeaterComponentWrapper>();
            for (Form_Table_Element__mdt cmp : [SELECT Id, DeveloperName,Form_Table__r.Group_Name__c,
                                                                   Form_Table__r.Column_1__c,
                                                                   Form_Table__r.Column_2__c,
                                                                   Form_Table__r.Column_3__c,
                                                                   Form_Table__r.Column_4__c,
                                                                   Form_Table__r.Column_5__c,
                                                                   Form_Table__r.Formula_Column_Name__c,
                                                                   Form_Table__r.Formula__c,
                                                                   
                                                                   Column_1_Component_Name__c, Column_2_Component_Name__c, 
                                                                   Column_3_Component_Name__c, Column_4_Component_Name__c, 
                                                                   Column_5_Component_Name__c, 
                                                                   
                                                                   Attribute_Name_Column_1_Component__c, Attribute_Name_Column_2_Component__c, 
                                                                   Attribute_Name_Column_3_Component__c, Attribute_Name_Column_4_Component__c, 
                                                                   Attribute_Name_Column_5_Component__c, 
                                                                   Attribute_Name_2_Column_1_Component__c, Attribute_Name_2_Column_2_Component__c, 
                                                                   Attribute_Name_2_Column_3_Component__c, Attribute_Name_2_Column_4_Component__c, 
                                                                   Attribute_Name_2_Column_5_Component__c, 
                                                                   Attribute_Name_3_Column_1_Component__c, Attribute_Name_3_Column_2_Component__c, 
                                                                   Attribute_Name_3_Column_3_Component__c, Attribute_Name_3_Column_4_Component__c, 
                                                                   Attribute_Name_3_Column_5_Component__c, 
                                                                
                                                                   Attribute_Value_Column_1_Component__c,Attribute_Value_Column_2_Component__c, 
                                                                   Attribute_Value_Column_3_Component__c,Attribute_Value_Column_4_Component__c, 
                                                                   Attribute_Value_Column_5_Component__c,
                                                                   Attribute_Value_2_Column_1_Component__c,Attribute_Value_2_Column_2_Component__c, 
                                                                   Attribute_Value_2_Column_3_Component__c,Attribute_Value_2_Column_4_Component__c, 
                                                                   Attribute_Value_2_Column_5_Component__c,
                                                                   Attribute_Value_3_Column_1_Component__c,Attribute_Value_3_Column_2_Component__c, 
                                                                   Attribute_Value_3_Column_3_Component__c,Attribute_Value_3_Column_4_Component__c, 
                                                                   Attribute_Value_3_Column_5_Component__c,
                                                      
                                                                   Display_Rank__c, Form_Table__c FROM Form_Table_Element__mdt where
                                                                   Form_Table__r.Group_Name__c = :groupName order by Display_Rank__c asc])
            {
                Map<String, Object> attributes = new Map<String, Object>();
                Map<String,String> attributeNameValue = new Map<String,String>();
                attributeNameValue.put(cmp.Attribute_Name_Column_1_Component__c,cmp.Attribute_Value_Column_1_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_2_Column_1_Component__c,cmp.Attribute_Value_2_Column_1_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_3_Column_1_Component__c,cmp.Attribute_Value_3_Column_1_Component__c);
                 prepareAttribute(attributes,attributeNameValue, cmp.Column_1_Component_Name__c,wrappedComponents,cmp);
                
                attributes = new Map<String, Object>();                
                attributeNameValue = new Map<String,String>();
                attributeNameValue.put(cmp.Attribute_Name_Column_2_Component__c,cmp.Attribute_Value_Column_2_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_2_Column_2_Component__c,cmp.Attribute_Value_2_Column_2_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_3_Column_2_Component__c,cmp.Attribute_Value_3_Column_2_Component__c);
                 prepareAttribute(attributes,attributeNameValue, cmp.Column_2_Component_Name__c,wrappedComponents,cmp);
                
                attributes = new Map<String, Object>();
                attributeNameValue = new Map<String,String>();
                attributeNameValue.put(cmp.Attribute_Name_Column_3_Component__c,cmp.Attribute_Value_Column_3_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_2_Column_3_Component__c,cmp.Attribute_Value_2_Column_3_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_3_Column_3_Component__c,cmp.Attribute_Value_3_Column_3_Component__c);
                 prepareAttribute(attributes,attributeNameValue, cmp.Column_3_Component_Name__c,wrappedComponents,cmp);
                
                attributes = new Map<String, Object>();
                attributeNameValue = new Map<String,String>();
                attributeNameValue.put(cmp.Attribute_Name_Column_4_Component__c,cmp.Attribute_Value_Column_4_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_2_Column_4_Component__c,cmp.Attribute_Value_2_Column_4_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_3_Column_4_Component__c,cmp.Attribute_Value_3_Column_4_Component__c);
                 prepareAttribute(attributes,attributeNameValue, cmp.Column_4_Component_Name__c,wrappedComponents,cmp);
                
                attributes = new Map<String, Object>();
                attributeNameValue = new Map<String,String>();
                attributeNameValue.put(cmp.Attribute_Name_Column_5_Component__c,cmp.Attribute_Value_Column_5_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_2_Column_5_Component__c,cmp.Attribute_Value_2_Column_5_Component__c);
                attributeNameValue.put(cmp.Attribute_Name_3_Column_5_Component__c,cmp.Attribute_Value_3_Column_5_Component__c);
                prepareAttribute(attributes,attributeNameValue, cmp.Column_5_Component_Name__c,wrappedComponents,cmp);                
                
            }                           
        return wrappedComponents;
    }
    
     /**
    * @Author Incapsulate
    * @Since 08-03-2019
    * @Description: 
    */
    private static void prepareAttribute(Map<String, Object> attributes,Map<String,String> attributeNameValue,String cmpName,List<RepeaterComponentWrapper> wrappedComponents,Form_Table_Element__mdt cmp){
        for(String key : attributeNameValue.keySet()){
            if(String.isNotEmpty(key)){
                putAttribute(attributes, key, 'String', attributeNameValue.get(key));  
            }           
        }
        prepareElement(attributes,cmpName,wrappedComponents,cmp);
    }
    
     /**
    * @Author Incapsulate
    * @Since 08-03-2019
    * @Description: 
    */
    private static List<RepeaterComponentWrapper> prepareElement(Map<String, Object> attributes,String cmpName,List<RepeaterComponentWrapper> wrappedComponents,Form_Table_Element__mdt cmp){                                 
                    RepeaterComponentWrapper.RepeaterCard rc = new RepeaterComponentWrapper.RepeaterCard();
                    rc.name = cmpName;
                    rc.metadataRecordDeveloperName = cmp.DeveloperName;
                    //for form table header
                    rc.listOfColumn = new List<String>();
                    rc.column1 = cmp.Form_Table__r.Column_1__c;
                    rc.column2 = cmp.Form_Table__r.Column_2__c;
                    rc.column3 = cmp.Form_Table__r.Column_3__c;
                    rc.column4 = cmp.Form_Table__r.Column_4__c;
                    rc.column5 = cmp.Form_Table__r.Column_5__c;
                    rc.formulaColumnName = cmp.Form_Table__r.Formula_Column_Name__c;
                    rc.formula = cmp.Form_Table__r.Formula__c;
                    rc.listOfColumn.add(cmp.Form_Table__r.Column_1__c);
                    rc.listOfColumn.add(cmp.Form_Table__r.Column_2__c);
                    rc.listOfColumn.add(cmp.Form_Table__r.Column_3__c);
                    rc.listOfColumn.add(cmp.Form_Table__r.Column_4__c);
                    rc.listOfColumn.add(cmp.Form_Table__r.Column_5__c);
                    RepeaterComponentWrapper rcw = new RepeaterComponentWrapper();
                    //element prepared with attribute infomation end here
                    rcw.sections.add(new RepeaterComponentWrapper(rc, attributes));               
                    wrappedComponents.add(rcw);
            return wrappedComponents;        
    }
   
     /**
    * @Author Incapsulate
    * @Since 08-03-2019
    * @Description: 
    */
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

}