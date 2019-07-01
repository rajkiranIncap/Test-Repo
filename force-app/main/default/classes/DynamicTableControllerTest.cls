/**
  * @author Incapsulate
  * @description Test Class used for creating DynamicTable.
*/
@istest
public class DynamicTableControllerTest {
    
    /**
    * @description Method to intialize the data
    **/
     static testMethod void init(){
        List<String> field_names = new List<String> ();
        List<String> override_field_type = new List<String> ();
        field_names.add('Id');
        field_names.add('Name');
        field_names.add('Account.Name');
        override_field_type.add('Id:id');
        Test.startTest();
            DynamicTableController.getColumnMetadata('Contact',field_names,field_names,field_names,field_names,override_field_type);
            DynamicTableController.getTotalRecords('Contact','');
            DynamicTableController.getRecords('Contact', field_names,'', 'Id', 'Desc', 10);
        Test.stopTest();    
    } 
    
    /**
    * @description Method to Generate Exception
    **/
    static testMethod void ExceptionGenerate(){
        List<String> field_names = new List<String> ();
        List<String> override_field_type = new List<String> ();
        field_names.add('Id');
        field_names.add('Name1');
        field_names.add('Account.Name');
        override_field_type.add('Id:id');
        Test.startTest();
            DynamicTableController.getColumnMetadata('Contact',field_names,field_names,field_names,field_names,override_field_type);
            DynamicTableController.getTotalRecords('Contact','');
            DynamicTableController.getRecords('Contact', field_names,'', 'Id', 'Desc', 10);
        Test.stopTest();    
    }   

     /**
    * @description Method to Generate Exception
    **/
    static testMethod void ExceptionGenerateTest(){
        List<String> field_names = new List<String> ();
        List<String> override_field_type = new List<String> ();
        field_names.add('Id');
        field_names.add('Name1');
        field_names.add('Account.Name');
        override_field_type.add('Id:id_c');
        Test.startTest();
        try{
            DynamicTableController.getColumnMetadata('Contact',field_names,field_names,field_names,field_names,override_field_type);
        }catch(Exception ex){
            
        }
        try{
            DynamicTableController.getTotalRecords('Contact','');
        }catch(Exception ex){
            
        }
        try{
            DynamicTableController.getRecords('Contact', field_names,'', 'Id', 'Desc', 10);
        }
        catch(Exception ex){
            
        }
        Test.stopTest();    
    } 
    /**
    * @description Method to Generate Exception
    **/
    static testMethod void ExceptionGenerateTestTwo(){
        DynamicTableController.ColumnMetadata dtc = new DynamicTableController.ColumnMetadata();
        Map<String, Schema.SObjectField> sobject_fields = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();
        List<String> relationship = 'AccountId'.split('\\.');
        Test.startTest();
        try{
        	dtc.populateRelationshipFieldDescribe('namespace', relationship ,sobject_fields);
        }Catch(DynamicTableController.DynamicTableException dt){
            System.assertEquals('Unknown relationship: ', dt.getMessage(), 'Exception occured');
        }
        Test.stopTest();
    }
}