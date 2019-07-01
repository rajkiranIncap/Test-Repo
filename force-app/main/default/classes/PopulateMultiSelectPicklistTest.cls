/**
    * 
    * @Author Incapsulate
    * @Since 25/02/2019
    * @Description Test Class to test the PopulateMultiSelectPicklist
    */
@isTest
public class PopulateMultiSelectPicklistTest {
	 /**
    * Method to test picklist values based on sobject api name and field api name.
    * Using standard sobject api name.
    *
    * @Author Incapsulate
    * @Since 25/02/2019
    */
    @isTest
    private static void testGetPicklistValues(){
        Test.startTest();
        	List<Map<string, string> > options = PopulateMultiSelectPicklist.getPicklistValues('Account','Type'); 
        	System.assertNotEquals(options, null, 'Picklist ');
        Test.stopTest();
    }
}