/**
* @Author Rajkiran Dewara
* @Since 24-06-2019
* @Description: Test class to coverage the FormTableController class.
*/
@isTest
public class TestFormTableController {
	
   /**
    * @Author Rajkiran Dewara
    * @Since 24-06-2019
    * @Description: Test method to verify the metadata record in the
    * metadata table
    */
    
    @isTest
    public static void testComponentsByGroupNameNew(){
        List<Form_Table__mdt> formtablemdt = [Select Group_Name__c From Form_Table__mdt];
        Test.startTest();
        for(Form_Table__mdt ftm:  formtablemdt){
            system.assertNotEquals(ftm, null, 'Data list ');
            List<Form_Table_Element__mdt> formtablelemntmdt = [Select Form_Table__c From Form_Table_Element__mdt where Form_Table__c = :ftm.id];
            system.assertNotEquals(formtablelemntmdt, null, 'Data list ');
            system.assertNotEquals(formtablelemntmdt.size(), 0, 'Data list size ');
            List<RepeaterComponentWrapper> listOfRepeaterDataDynamicdata = FormTableController.getComponentsByGroupNameNew(formtablemdt[0].Group_Name__c);
            system.assertNotEquals(listOfRepeaterDataDynamicdata, null, 'Data list ');
            //system.assertNotEquals(listOfRepeaterDataDynamicdata.size(), 0, 'Data list ');
            if(listOfRepeaterDataDynamicdata != null && listOfRepeaterDataDynamicdata.size()>0){
                for(RepeaterComponentWrapper rcw :listOfRepeaterDataDynamicdata)
                system.assertNotEquals(rcw, null, 'Attributes ');            
            }
        }
        Test.stopTest();
    }
}