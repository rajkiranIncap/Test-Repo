/**
* @Author Incapsulate
* @Since 3-28-2019
* @Description: Utility methods for the Test Class
*/
public class UtilTest {
	
    //Create Form Records
    public static Form__c createForm(String FormName, String FormGroupName , String sObjectAPIName){
        Form__c form = new Form__c(Name = FormName,Form_Group_Name__c=FormGroupName,sObject_API_Name__c=sObjectAPIName);
        return form;
    }
    
    //Create Element Records
    public static Element__c createElement(String ElementName, Integer DisplayRank, Id ElementId , String componentName){
        Element__c element = new Element__c(Name=ElementName,Display_Rank__c=DisplayRank,Element__c=ElementId,Lightning_Component_Name__c=componentName);
        return element;
    }
    
    //Create Element Attributes Records
    public static List<Element_Attribute__c> createElementAttributes(List<String> EleAttributesNames, Id ElementId, Map<String,String> LAttributeValueMap){
        List<Element_Attribute__c> ElementAttributeList = new List<Element_Attribute__c>();
        Integer i=0;
        for (String LAttributeName : LAttributeValueMap.keySet()){
            Element_Attribute__c elementAttribute = new Element_Attribute__c(Name=EleAttributesNames[i],Element__c=ElementId,Lightning_Attribute_Name__c=LAttributeName,Value__c=LAttributeValueMap.get(LAttributeName));
        	ElementAttributeList.add(elementAttribute);
            i++;
        }
        return ElementAttributeList;
    }
    
    //Create FormElement Records
    public static Form_Element__c createFormElement(String FormElementName, Id ElementId, Id FormId){
        Form_Element__c FormElement = new Form_Element__c(Name=FormElementName,Element__c=ElementId,Form__c=FormId);
        return FormElement;
    }
    
    //create Account Records
    public static List<Account> createAccounts(Integer count){
        List<Account> AccountList = new List<Account>();
        for(Integer i=1 ; i<=count ; i++){
            Account acc = new Account(Name='Test Account '+i);
            AccountList.add(acc);
        }
        return AccountList;
    }
    
    //create Contact related with an Account Records
    public static List<Contact> createContacts(Integer count,Id AccId){
         List<Contact> ContactList = new List<Contact>();
        for(Integer i=1 ; i<=count ; i++){
            Contact con = new Contact(FirstName='Test '+i,LastName='Contact '+i,AccountId=AccId);
            ContactList.add(con);
        }
        return ContactList;
    }
}