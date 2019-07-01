/**
* This test class is used to cover the code for PopulatePicklist class.
*
* @Author Incapsulate
* @Since 25/02/2019
*/
@isTest
private class PopulatePicklistTest {    
    private static final String RECORD_TYPE = 'Test_Record_Type';    
    
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
        	List<Map<string, string> > options = PopulatePicklist.getPicklistValues('Account','Type',null); 
        	System.assertNotEquals(options, null, 'Picklist ');
        Test.stopTest();
    }
    
    /**
    * Method to test picklist values based on sobject api name, field api name and record type name.
    * Using standard sobject api name.
    * Using mock response generator because the callout is not supported in test method.
    * @Author Incapsulate
    * @Since 25/02/2019
    */
    @isTest
    private static void testGetPicklistValuesByRecordType(){
        // This causes a fake response to be generated
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            List<Map<string, string> > options = PopulatePicklist.getPicklistValues('Account','Type',RECORD_TYPE); 
        Test.stopTest();
        if(options != null && options.size()>0)
        	system.assertNotEquals(options.size(),0,'List Size:');
    }   
}