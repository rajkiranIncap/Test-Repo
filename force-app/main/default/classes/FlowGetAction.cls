public class FlowGetAction {

    public static List<ItemsResponse> getItems(List<ItemsRequest> requests) {
        //List<FlowGetAction.JsonKeyValue> jk = 
        //(List<FlowGetAction.JsonKeyValue>)JSON.deserialize('[{"key": "email","value": "a@g.com"}]', 
        //List<FlowGetAction.JsonKeyValue>.class);
        List<ItemsResponse> results = new List<ItemsResponse>();
        ItemsResponse response = new ItemsResponse();
        String columns ='';
        String columnAndValue ='';
        
        for(ItemsRequest req : requests) {
            if(!String.isBlank(req.jsonListKeyValues)){
                List<FlowGetAction.JsonKeyValue> jkvlist = 
                (List<FlowGetAction.JsonKeyValue>)JSON.deserialize(req.jsonListKeyValues, 
                List<FlowGetAction.JsonKeyValue>.class);
                for(FlowGetAction.JsonKeyValue jkv: jkvlist){
                    if(!String.isBlank(columns)){
                        columns = columns + ',';
                    }
                    if(!String.isBlank(columnAndValue)){
                        columnAndValue = columnAndValue + ' and ';
                    }
                   columns = columns + jkv.key;
                    if(jkv.type == 'text'){
                   		columnAndValue = columnAndValue + jkv.key+'=\''+jkv.value+'\'';
                    }else{
                   		columnAndValue = columnAndValue + jkv.key+'='+jkv.value;
                    }
                }
            }
        }
        response.objectDetails = JSON.serialize(Database.query('Select ' +columns +' from Account where '+columnAndValue));
        results.add(response);
        return results;
    }
    public class ItemsRequest {
        @InvocableVariable(label='Key Column Name or Value.[{"key": "email","value": "a@g.com","type":"text"}]' description='Type can be text number or boolean' required=true)
        public String jsonListKeyValues = '[{"key": "email","value": "a@g.com","type":"text"}]';
    }
    
    public class ItemsResponse {
        @InvocableVariable(label='Json String sObject Details' description='' required=true)
        public String objectDetails;        
    }
    
    public class JsonKeyValue {
        public String key;
        public String value;
        public String type;
    }
}