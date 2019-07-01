/**
* @Author Incapsulate
* @Description: 
*/
public with sharing class FlowRepeaterGetAction {
    /**
    * @Author Incapsulate
    * @Description: 
    */
    @InvocableMethod(label='Get Repeater Items' description='')
    public static List<GetItemsResult> getItems(List<GetItemsRequest> requests) {
        List<GetItemsResult> results = new List<GetItemsResult>();
        for(GetItemsRequest req : requests) {
            List<String> fields = new List<String>();
            if(req.isFormTableData){
                //TODO: below line needs to be make dynamic
                //making default value column but this column will give error
                //on run time if does not exist in the table need to make changes
                //once designed is fix for form table component
                if(String.isBlank(req.metaDataColumnName)){
                	fields.add('Metadata_Record_Developer_Name__c');
                }else{
                    fields.add(req.metaDataColumnName);
                }
                
                List<RepeaterComponentWrapper> wrappers = FormTableController.getComponentsByGroupNameNew(req.groupName);
                for(RepeaterComponentWrapper wrap : wrappers) {
                    if(wrap.sections[0].attributes.containsKey('fieldBinding')) {
                        fields.add((String) wrap.sections[0].attributes.get('fieldBinding'));                        
                    }
                }
            }else{
                List<DynamicRepeaterController.DynamicComponentWrapper> wrappers = DynamicRepeaterController.getComponentsByGroupName(req.groupName);
                for(DynamicRepeaterController.DynamicComponentWrapper wrap : wrappers) {
                    if(wrap.attributes.containsKey('fieldBinding')) {
                        fields.add((String) wrap.attributes.get('fieldBinding'));
                    }
                }
            }

            GetItemsResult result = new GetItemsResult();
            if(fields.isEmpty()) {
                result.jsonItems = JSON.serialize(new List<SObject>());
            }
            else {
                String query = 'SELECT ';
                query += JSON.serialize(new Set<String>(fields)).replaceAll('["\\[\\]]', '');
                query += ' FROM ' + req.objectType;
                
                List<String> filters = new List<String>();
                if(String.isNotBlank(req.parentId) && String.isNotBlank(req.parentField)) {
                    filters.add(req.parentField + '=\'' + req.parentId + '\'');
                }
                if(String.isNotBlank(req.recordTypeId)) {
                    filters.add('RecordTypeId=\'' + req.recordTypeId + '\'');
                }
                if(!filters.isEmpty()) {
                    query += ' WHERE ' + JSON.serialize(filters).replaceAll('["\\[\\]]', '').replace(',', ' AND ');
                    result.jsonItems = JSON.serialize(Database.query(query));
                }else{
                    result.jsonItems = JSON.serialize(new List<SObject>());
                }
                
            }
            
            results.add(result);
        }
        
        return results;
    }

    @testVisible
    public class GetItemsRequest {
        @InvocableVariable(label='SObject API Name' description='' required=true)
        public String objectType;
        @InvocableVariable(label='Metadata Group Name' description='' required=true)
        public String groupName;
        @InvocableVariable(label='Record Type ID' description='' required=false)
        public String recordTypeId;
        @InvocableVariable(label='Parent ID' description='' required=false)
        public String parentId;
        @InvocableVariable(label='Parent ID Field' description='' required=false)
        public String parentField;
        @InvocableVariable(label='Form Table' description='Give the default value false if not in use.' required=true)
        public Boolean isFormTableData = false;
        @InvocableVariable(label='Metadata Column Name' description='If isFormTableData attribute is true than must have column name' required=false)
        public String metaDataColumnName = 'Metadata_Record_Developer_Name__c';
    }

    public class GetItemsResult {
        @InvocableVariable(label='Repeater Input' description='' required=true)
        public String jsonItems;
    }
}