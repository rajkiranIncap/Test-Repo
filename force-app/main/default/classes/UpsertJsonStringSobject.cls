/**
* @Author Incapsulate
* @Since 12-03-2019
* @Description: This class is to use in flow as a generic invocable save update of the jsonStringSobject
* 				 as flow does not support the sobject/object design attributes.
InvocableVariable Considerations
        Other annotations can’t be used with the InvocableVariable annotation.
        Only global and public variables can be invocable variables.
        The invocable variable can’t be one of the following:
        A type such as an interface, class, or enum.
        A non-member variable such as a static or local variable.
        A property.
        A final variable.
        Protected or private.
        The data type of the invocable variable must be one of the following:
        A primitive data type or a list of a primitive data type – the generic Object type is not supported.
        An sObject type or a list of an sObject type – the generic sObject type is not supported.

        For managed packages:
        Public invocable variables can be set in flows and processes within the same managed package.
        Global invocable variables can be set anywhere in the subscriber org. Only global invocable variables appear in Flow Builder and Process Builder in the subscriber org. 
*/
public class UpsertJsonStringSobject {
	/**
     * @Author Incapsulate
     * @Since 12-03-2019
     * @Description: This method is to use in flow as a generic invocable save update of the jsonStringSobject
     * 				 as flow does not support the sobject/object design attributes.
     * @Param jsonInput list of json string holding the sobject data to upsert.   
     * 
	**/
    @InvocableMethod(label='Get sObject Record Id' description='Generic method to use to save or update the sobject')
    public static List<ID> getListOfSobjects(List<String> jsonInput) {
        List<Id> listOfId  = new List<Id>();
        Map<String, Object> jsonMapClone =  (Map<String, Object>)JSON.deserializeUntyped(jsonInput[0]);
        try{
            Map<String, Object> jsonMap =  (Map<String, Object>)JSON.deserializeUntyped(jsonInput[0]);
            
            List<List<sObject>> relatedsObjectList =  new List<List<sObject>>();
            String parentFieldName = null;
            for (String fieldName : jsonMap.keySet()){
					System.debug('field name is ' + fieldName);
                if(fieldName== 'id'){
                    if(String.isEmpty(String.valueOf(jsonMap.get(fieldName)))){
                        jsonMap.remove(fieldName);
                    }else{
                    	jsonMap.put('id',(ID)jsonMap.get(fieldName));
                    }
                }
                if(fieldName.contains('relatedsObject')){
                    /*List<sObject> sObjectList =  new List<sObject>();
                    System.debug('>>>'+jsonMap.get(String.valueOf(fieldName)));
                    String jsonString = JSON.serialize(jsonMap.get(String.valueOf(fieldName)));
                    Map<String, Object> relatedJsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                    //Map<String, Object> relatedJsonMap = (Map<String, Object>)jsonMap.get(String.valueOf(fieldName));
                    System.debug('relatedJsonMap>>>'+relatedJsonMap);
                    for (String relatedFieldName : relatedJsonMap.keySet()){
                        String jsonin = JSON.serialize(relatedJsonMap.get(String.valueOf(relatedFieldName)));
                        System.debug('jsonin>>>'+jsonin);
                    	Map<String, Object> relatedJsonsObjectMap =  (Map<String, Object>)JSON.deserializeUntyped(jsonin);
                        System.debug('relatedJsonsObjectMap>>>'+relatedJsonsObjectMap);
                        sObject sobj = getSobject(relatedJsonsObjectMap,jsonin);
                        System.debug('relatedSobject::'+sobj);
                        sObjectList.add(sobj);
                    }
                    System.debug(' sObjectList:::'+sObjectList);*/
                    jsonMap.remove(fieldName);
                    /*System.debug('after remove jsonMap:::'+jsonMap);
                    relatedsObjectList.add(sObjectList);
                    System.debug(' relatedsObjectList:::'+relatedsObjectList);*/
                }                
        	}
            //Set<String> jsonKeys = jsonMap.keySet();
           // System.debug('jsonkeys::'+jsonKeys);
            sObject parentSobj = getSobject(jsonMap,JSON.serialize(jsonMap));
            upsert parentSobj;
            listOfId.add((ID)parentSobj.id);
            System.debug('>>>>>>>>parentSobj>>>>>'+parentSobj);
            jsonMapClone.put('id',parentSobj.id);
            if(parentSobj != null && parentSobj.id != null)
            for (String fieldName : jsonMapClone.keySet()){
					System.debug('field name is ' + fieldName);
                if(fieldName.contains('relatedsObject')){
                    List<sObject> sObjectList =  new List<sObject>();
                    System.debug('>>>'+jsonMapClone.get(String.valueOf(fieldName)));
                    String jsonString = JSON.serialize(jsonMapClone.get(String.valueOf(fieldName)));
                    Map<String, Object> relatedJsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                    //Map<String, Object> relatedJsonMap = (Map<String, Object>)jsonMapClone.get(String.valueOf(fieldName));
                    System.debug('relatedJsonMap>>>'+relatedJsonMap);
                    for (String relatedFieldName : relatedJsonMap.keySet()){
                       /* String fieldvalue = String.valueOf(relatedJsonMap.get(fieldName));
                        if(fieldvalue == 'parentFieldId'){
                            System.debug('(ID)parentSobj.id:::'+(ID)parentSobj.id);
                            relatedJsonMap.put(fieldName,(ID)parentSobj.id);
                        }*/
                        String jsonin = JSON.serialize(relatedJsonMap.get(String.valueOf(relatedFieldName)));
                        System.debug('jsonin>>>'+jsonin);
                    	Map<String, Object> relatedJsonsObjectMap =  (Map<String, Object>)JSON.deserializeUntyped(jsonin);
                        
                        for (String relatedFieldNameRef : relatedJsonsObjectMap.keySet()){
                            String fieldvalue = String.valueOf(relatedJsonsObjectMap.get(relatedFieldNameRef));
                            if(fieldvalue == 'parentFieldId'){
                                System.debug('(ID)parentSobj.id:::'+(ID)parentSobj.id);
                                relatedJsonsObjectMap.put(relatedFieldNameRef,(ID)parentSobj.id);
                            }
                        }
                        
                        
                        System.debug('relatedJsonsObjectMap>>>'+relatedJsonsObjectMap);
                        sObject sobj = getSobject(relatedJsonsObjectMap,JSON.serialize(relatedJsonsObjectMap));
                        System.debug('relatedSobject::'+sobj);
                        sObjectList.add(sobj);
                        
                    }
                    System.debug(' sObjectList:::'+sObjectList);
                    //jsonMapClone.remove(fieldName);
                    System.debug('after remove jsonMap:::'+jsonMapClone);
                    relatedsObjectList.add(sObjectList);
                    System.debug(' relatedsObjectList:::'+relatedsObjectList);
                }
                
        	}
            
            
            
            
            List<sObject> listToInsert = new List<sObject>();
            List<sObject> listToUpdate = new List<sObject>();
            List<sObject> listToDelete = new List<sObject>();
            /**
             * 
             * belwo DML inside the for loop will not exceed the limitation
             * because i am preparing the list of list<sobject> for related objects
             * and one parent will not have more related objects max to 10-20
             * 
             */
            if(!relatedsObjectList.isEmpty()){
                for(List<sObject> lstSobject: relatedsObjectList){
                    for(sObject obj: lstSobject){
                        if(obj.ID != null){
                            listToUpdate.add(obj);
                        }else if(obj.ID == null){
                           listToInsert.add(obj); 
                        }
                    }
                    //insert lstSobject;
                }                
            }            
            if(!listToUpdate.isEmpty()){
                update listToUpdate;
            }
            if(!listToInsert.isEmpty()){
                insert listToInsert;
            }
           /* String jsonAttribute = JSON.serialize(jsonMap.get('attributes'));
            Attributes att  = (Attributes) JSON.deserialize(jsonAttribute,Attributes.class);
            String objectName = att.type;
            Type theClass = Type.forName(ObjectName);
            sObject objInstance = (SObject)JSON.deserialize(jsonInput[0],theClass);*/
            
            //upsert objInstance;            
            //listOfId.add((ID)objInstance.id);
        }catch(Exception ex){
            System.debug('Error occured while upsert:'+ex.getMessage());
            System.debug('Error occured while upsert:'+ex.getStackTraceString());
        }
        List<String> jsonMapClonelst = new List<String>();
        jsonMapClonelst.add(JSON.serialize(jsonMapClone));
		return  listOfId;//jsonMapClonelst;
    }
    public class Attributes{
        String type;
        String url;
    }
    
    /**
    * @Author Incapsulate
    * @Since 12-03-2019
    * @Description: The method is used to convert the input json to sobject instance.
    * This method also handle the deleted field from salesforce:
    * Ex: if admin delete the field from sObject and the generic form still hold the
    * field on layout, it will be part of the jsonMap but while deserialize the json
    * It will ignore the deleted field and save the rest data. 
    */
    private static sObject getSobject(Map<String, Object> jsonMap,String jsonSobject){
        String jsonAttribute = JSON.serialize(jsonMap.get('attributes'));
            Attributes att  = (Attributes) JSON.deserialize(jsonAttribute,Attributes.class);
            String objectName = att.type;
            Type theClass = Type.forName(ObjectName);
            sObject objInstance = (SObject)JSON.deserialize(jsonSobject,theClass);
        return objInstance;
    }
}