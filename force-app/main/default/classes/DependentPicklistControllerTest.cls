/**
* @Author Incapsulate
* @Since 02-05-2019
* @Description: Test Class to test the dependent picklist values based on object api name or field api name
*/
@isTest
public with sharing class DependentPicklistControllerTest {
    

    /**
    * @Author Incapsulate
    * @Since 02-05-2019
    * @Description: method to get the picklist value based on standard sobject api name or standard field api name
    */
	@isTest
    public static void getSelectOptionsTest() {
    	String objectName = 'Account';
    	String fld = 'Industry';

		Test.startTest();
		List<String> curOptions = DependentPicklistController.getSelectOptions( objectName, fld);
		Test.stopTest();

		System.assertNotEquals(curOptions.size(),0,'Picklist values');
    }
    
    /**
    * @Author Incapsulate
    * @Since 02-05-2019
    * @Description: method to get the picklist value based on standard sobject api name or standard field api name
    */
	@isTest
    public static void getDependentMapFromSobjectOrDependentpicklistTest() {
        Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
		Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= testAccount.id;
		insert cont;
    	String objectName = 'Account';
    	String fld = 'Industry';
        string contrfieldApiName = 'Name';
        string depfieldApiName = 'Name';

		Test.startTest();
		Map<String,List<DependentPicklistController.PicklistEntryWrapper>> curOptions = DependentPicklistController.getDependentMapFromSobjectOrDependentpicklist(true,
                                                                                                      objectName,contrfieldApiName,depfieldApiName
                                                                                                     ,objectName,
                                                                                                     'contacts'
                                                                                                     );
		Test.stopTest();

		System.assertNotEquals(curOptions,null,'Picklist values');
    }
    
    /**
    * @Author Incapsulate
    * @Since 02-05-2019
    * @Description: method to get the picklist value based on standard sobject api name or standard field api name
    */
	@isTest
    public static void getDependentMapFromSobjectOrDependentpicklistOtherTest() {
        Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
		Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= testAccount.id;
		insert cont;
    	String objectName = 'Account';
    	String fld = 'Industry';
        string contrfieldApiName = 'Name';
        string depfieldApiName = 'Name';

		Test.startTest();
		Map<String,List<DependentPicklistController.PicklistEntryWrapper>> curOptions = DependentPicklistController.getDependentMapFromSobjectOrDependentpicklist(false,
                                                                                                      objectName,contrfieldApiName,depfieldApiName
                                                                                                     ,objectName,
                                                                                                     'contacts'
                                                                                                     );
		Test.stopTest();

		System.assertNotEquals(curOptions,null,'Picklist values');
    }
     
     /**
    * @Author Incapsulate
    * @Since 02-05-2019
    * @Description: method to get the picklist value based on standard sobject api name or standard field api name
    */
	@isTest
    public static void base64ToBitsTest() {
       
		Test.startTest();
		String curOptions = DependentPicklistController.base64ToBits('testvalidfor');
		Test.stopTest();

		System.assertNotEquals(curOptions,null,'Values');
    }
    
    
}