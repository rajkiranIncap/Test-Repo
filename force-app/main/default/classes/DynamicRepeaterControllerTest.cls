/**
* @Author Incapsulate
* @Since 21-06-2019
* @Description:Test Class for DynamicControllerILALite
*/
@isTest
public class DynamicRepeaterControllerTest {
    @isTest
    public static void testgetComponentsByGroupName(){
        /*Repeater_Component__mdt rc = new Repeater_Component__mdt(); 
        rc.Label = 'Amount paid new';
        rc.DeveloperName = 'Amount_paid_new';
        rc.Component_Name__c = 'c:lightningInput';
        rc.Component_Type__c = 'number';
        rc.Display_Rank__c = 1;
        rc.Group_Name__c = 'Tax Information';
        rc.Attribute_1_Name__c = 'label';
        rc.Attribute_1_Value__c = 'Amount paid';
        rc.Attribute_1_Type__c = 'String';
        rc.Attribute_2_Name__c = 'fieldBinding';
        rc.Attribute_2_Type__c = 'String';
        rc.Attribute_2_Value__c = 'Amount_paid__c';
        return rc;*/
        
        /**
        * @Author Incapsulate
        * @Since 21-06-2019
        * @Description:Test Class for getComponentsByGroupName,getRecords method of DynamicControllerILALite class.
        */
        
        list<DynamicRepeaterController.DynamicComponentWrapper> lst = DynamicRepeaterController.getComponentsByGroupName('Tax Information');
        
        list<string> lststring = new list<string>();
        lststring.add('Collector_s_property_identification__c');
        lststring.add('Amount_paid__c');
        lststring.add('Date_paid__c');
        lststring.add('Period_covered_From__c');
        lststring.add('Period_covered_To__c');
        lststring.add('Type_of_tax_or_assessment__c');
        lststring.add('Type_of_tax_or_assessment__c');
        Test.startTest();
         Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
		Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= testAccount.id;
		insert cont;
        
        
        List<SObject> lstreturn =  DynamicRepeaterController.getRecords('Tex_Information__c', null, null , 'HUD_Claim_form__c', lststring);
        system.assertEquals(false, lstreturn.size() > 1);
        List<SObject> lstreturn2 = DynamicRepeaterController.getRecords('', null, null , 'HUD_Claim_form__c', lststring); 
        system.assertEquals(false, lstreturn2.size() > 1);
        Test.stopTest();
        
        
    }

}