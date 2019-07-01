/**
* @Author Incapsulate
* @Since 27-06-2019
* @Description: Test class to coverage the FlowRepeaterGetActionTest class.
*/
@isTest
public class FlowRepeaterGetActionTest {
	/**
    * @Author Incapsulate
    * @Description: Test method to get the repeater components
    *  data
    */
    @isTest
    public static void testRepeaterItems(){
        Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
        
        Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= testAccount.id;
		insert cont;
        
        Contact cont1 = new Contact();
		cont1.FirstName='Test1';
		cont1.LastName='Test1';
		cont1.Accountid= testAccount.id;
		insert cont1;
		
        FlowRepeaterGetAction.GetItemsRequest gr = new FlowRepeaterGetAction.GetItemsRequest();
        gr.isFormTableData = false;
        gr.parentId = testAccount.id;
        gr.parentField = 'AccountId';
        
        
        List<FlowRepeaterGetAction.GetItemsRequest> ls = new  List<FlowRepeaterGetAction.GetItemsRequest>();
        ls.add(gr);
        Test.startTest();
       	 	List<FlowRepeaterGetAction.GetItemsResult> lsnew = FlowRepeaterGetAction.getItems(ls);
        Test.stopTest();
        
        System.assertNotEquals(lsnew, null,'Contact list ');
               
    }
    
    /**
    * @Author Incapsulate
    * @Since 27-06-2019
    * @Description: Test method to get the form table data
    */
    @isTest
    public static void testGetFormItems(){
        Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
        
        Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= testAccount.id;
		insert cont;
        
        Contact cont1 = new Contact();
		cont1.FirstName='Test1';
		cont1.LastName='Test1';
		cont1.Accountid= testAccount.id;
		insert cont1;
		
        FlowRepeaterGetAction.GetItemsRequest gr = new FlowRepeaterGetAction.GetItemsRequest();
        gr.isFormTableData = true;
        gr.parentId = testAccount.id;
        gr.objectType = 'Contact';
        gr.parentField = 'AccountId';
       // gr.groupName = 'Conveyance claim';
        gr.metaDataColumnName = 'name';
        
        List<FlowRepeaterGetAction.GetItemsRequest> ls = new  List<FlowRepeaterGetAction.GetItemsRequest>();
        ls.add(gr);
        Test.startTest();
       	 	List<FlowRepeaterGetAction.GetItemsResult> lsnew = FlowRepeaterGetAction.getItems(ls);
        Test.stopTest();
        
        System.assertNotEquals(lsnew, null,'Contact list ');
               
    }
}