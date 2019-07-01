/**
* @Author Incapsulate
* @Description: 
*/
public with sharing class FlowRepeaterSaveAction {
  	/**
    * @Author Incapsulate
    * @Description: 
    */
    @InvocableMethod(label='Save Repeater Items' description='')
    public static void saveItems(List<SaveItemsRequest> requests) {
        List<SObject> toInsert = new List<SObject>();
        List<SObject> toUpdate = new List<SObject>();
        List<SObject> toDelete = new List<SObject>();
        
        for(SaveItemsRequest req : requests) {
            Map<String, List<SObject>> saveMap = (Map<String, List<SObject>>) JSON.deserialize(req.jsonSaveMap, Map<String, List<SObject>>.class);
            
            if(saveMap.containsKey('saved')) {
                List<SObject> toSave = saveMap.get('saved');
                List<RecordType> recordType = null;
                if(req.recordTypeDeveloperName != null && !String.isBlank(req.recordTypeDeveloperName)){
                    String recordTypeName = req.recordTypeDeveloperName;
                   recordType =  [SELECT Id FROM RecordType where IsActive = true and DeveloperName = :recordTypeName];
                }
                if(req.parentId != NULL && req.parentId != NULL){
                    req.periodicFormId = req.parentId;
                }
                for(SObject item : toSave) {
                    if(item.get('Id') == null || String.isBlank((String) item.get('Id'))) {
                        
                        if(req.periodicFormId != NULL && req.periodicFormField != NULL){
                            item.put(req.periodicFormField,req.periodicFormId);
                        }
                        if(recordType != null && recordType.size()==1){
                            item.put('RecordTypeId',recordType[0].Id);
                        }
                        toInsert.add(item);
                    }
                    else {
                        toUpdate.add(item);
                    }
                }
            }
            if(saveMap.containsKey('deleted')) {
                toDelete.addAll(saveMap.get('deleted'));
            }
        }

        if(!toInsert.isEmpty()) { insert toInsert; }
        if(!toUpdate.isEmpty()) { update toUpdate; }
        if(!toDelete.isEmpty()) { delete toDelete; }
    }

    @testVisible
    public class SaveItemsRequest {
        @InvocableVariable(label='Repeater Output' description='' required=true)
        public String jsonSaveMap;
        @InvocableVariable(label='Periodic Form Field' description='')
        public String periodicFormField;
        @InvocableVariable(label='Periodic Form Id' description='')
        public Id periodicFormId;
         @InvocableVariable(label='Parent Id' description='')
        public Id parentId;
        @InvocableVariable(label='Record Type Developer Name' description='')
        public String recordTypeDeveloperName = null;
    }
}