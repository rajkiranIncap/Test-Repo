/**
    * Test class to test the piclist values for the sobject.
    *
    * @Author Incapsulate
    * @Since 25/02/2019
    */
@isTest
public class PopulatePicklistServiceTest {
 /**
    * Method to test picklist values based on sobject api name and field api name.
    * Using standard sobject api name.
    *
    * @Author Incapsulate
    * @Since 25/02/2019
    */
    @isTest
    private static void testGetPicklistValues(){
        Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
		Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= testAccount.id;
		insert cont;
		
        Test.startTest();
        	List<Map<string, string> > options = PopulatePicklistService.getFromSobject('AccountId','Contact',new List<Map<string, string> >());
        	System.assertNotEquals(options, null, 'Picklist ');
        Test.stopTest();
    }
    
    
    @isTest
    private static void testGetPicklistValuesBasedOnRecordType(){
        Test.startTest();
        try{
        	PopulatePicklistService.getPicklistValueByRecordType('Account', 'Type', 'dummyRecord',new List<Map<string, string> >());        	
        }catch(AuraHandledException ex){
            System.assertEquals('Error occured while fetching the picklist values:', ex.getMessage(),'Error Message ');
        }
        Test.stopTest();
    }
 	
    @isTest
    private static void testCheckAccess(){
        String[] fields = new String[]{'Name'};
        Test.startTest();
        try{
        	PopulatePicklistService.checkAccess('Account',fields , 'Read');
        }catch(AuraHandledException ex){
            System.assertEquals('Error occured while fetching the picklist values:', ex.getMessage(),'Error Message ');
        }
        Test.stopTest();
    }
    
    
    
    
    
}