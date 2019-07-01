/**
* @Author Incapsulate
* @Since 27-06-2019
* @Description: Test class to coverage the FlowRepeaterSaveAction class.
*/
@isTest
public class FlowRepeaterSaveActionTest {
	/**
    * @Author Incapsulate
    * @Since 27-06-2019
    * @Description: Test method to save the repeater components
    * or form table data
    */
    @isTest
    public static void testSaveItems(){
        Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
        FlowRepeaterSaveAction.SaveItemsRequest si = new FlowRepeaterSaveAction.SaveItemsRequest();
        si.jsonSaveMap = '{"saved":[{"Name":"contanct name","LastName":"Lastname","SObjectType":"Contact","attributes":{"type":"Contact"}}],"deleted":[]}';
        si.parentId = testAccount.id;
        si.periodicFormField = 'AccountId';
        List<FlowRepeaterSaveAction.SaveItemsRequest> ls = new  List<FlowRepeaterSaveAction.SaveItemsRequest>();
        ls.add(si);
        Test.startTest();
        	FlowRepeaterSaveAction.saveItems(ls);
        Test.stopTest();
        List<Contact> lstcotact = [Select id from Contact];
        System.assertNotEquals(lstcotact, null,'Contact list ');
        System.assertEquals(1, lstcotact.size(),'Contact created ');        
    }
}