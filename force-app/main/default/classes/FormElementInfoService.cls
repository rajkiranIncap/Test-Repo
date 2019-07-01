/**
* @Author Incapsulate
* @Since 12-03-2019
* @Description: 
*/
public class FormElementInfoService {
    
    @AuraEnabled
    public static List<RepeaterComponentWrapper> getComponentsByGroupNameCustomMetadata(String groupName) {
        List<Repeater_Component__mdt> components = [
            SELECT Id, Group_Name__c, Display_Rank__c, Component_Name__c,Component_Type__c,
            Attribute_1_Name__c, Attribute_1_Type__c, Attribute_1_Value__c,
            Attribute_2_Name__c, Attribute_2_Type__c, Attribute_2_Value__c,
            Attribute_3_Name__c, Attribute_3_Type__c, Attribute_3_Value__c,
            Attribute_4_Name__c, Attribute_4_Type__c, Attribute_4_Value__c,
            Attribute_5_Name__c, Attribute_5_Type__c, Attribute_5_Value__c,
            Attribute_6_Name__c, Attribute_6_Type__c, Attribute_6_Value__c,
            Attribute_7_Name__c, Attribute_7_Type__c, Attribute_7_Value__c,
            Attribute_8_Name__c, Attribute_8_Type__c, Attribute_8_Value__c,
            Attribute_9_Name__c, Attribute_9_Type__c, Attribute_9_Value__c,
            Attribute_10_Name__c, Attribute_10_Type__c, Attribute_10_Value__c
            FROM Repeater_Component__mdt
            WHERE Group_Name__c = :groupName
            ORDER BY Display_Rank__c ASC
        ];
        
        List<RepeaterComponentWrapper> wrappedComponents = new List<RepeaterComponentWrapper>();
        for(Repeater_Component__mdt cmp : components) {
            //cmp.Component_Name__c = cmp.Component_Name__c;
            Map<String, Object> attributes = new Map<String, Object>();
            putAttribute(attributes, cmp.Attribute_1_Name__c, cmp.Attribute_1_Type__c, cmp.Attribute_1_Value__c);
            putAttribute(attributes, cmp.Attribute_2_Name__c, cmp.Attribute_2_Type__c, cmp.Attribute_2_Value__c);
            putAttribute(attributes, cmp.Attribute_3_Name__c, cmp.Attribute_3_Type__c, cmp.Attribute_3_Value__c);
            putAttribute(attributes, cmp.Attribute_4_Name__c, cmp.Attribute_4_Type__c, cmp.Attribute_4_Value__c);
            putAttribute(attributes, cmp.Attribute_5_Name__c, cmp.Attribute_5_Type__c, cmp.Attribute_5_Value__c);
            putAttribute(attributes, cmp.Attribute_6_Name__c, cmp.Attribute_6_Type__c, cmp.Attribute_6_Value__c);
            putAttribute(attributes, cmp.Attribute_7_Name__c, cmp.Attribute_7_Type__c, cmp.Attribute_7_Value__c);
            putAttribute(attributes, cmp.Attribute_8_Name__c, cmp.Attribute_8_Type__c, cmp.Attribute_8_Value__c);
            putAttribute(attributes, cmp.Attribute_9_Name__c, cmp.Attribute_9_Type__c, cmp.Attribute_9_Value__c);
            putAttribute(attributes, cmp.Attribute_10_Name__c, cmp.Attribute_10_Type__c, cmp.Attribute_10_Value__c);
            
            putAttribute(attributes, 'type', 'String', cmp.Component_Type__c);
            //wrappedComponents.add(new RepeaterComponentWrapper(cmp, attributes));
            RepeaterComponentWrapper.RepeaterCard rc = new RepeaterComponentWrapper.RepeaterCard();
                rc.name = cmp.Component_Name__c;   
                RepeaterComponentWrapper rcw = new RepeaterComponentWrapper();
                //element prepared with attribute infomation end here
                rcw.sections.add(new RepeaterComponentWrapper(rc, attributes));
               // System.debug('Label::'+record.Element__r.Label__c);
                //rcw.label = record.Element__r.Label__c;
                wrappedComponents.add(rcw);                
        }
        
        return wrappedComponents;
    }
    
     
    
    /**
    * @Author Incapsulate
    * @Since 12-03-2019
    * @Description: 
    */
    public static List<RepeaterComponentWrapper> getComponentsByGroupNameNew(String groupName) {
        List<RepeaterComponentWrapper> wrappedComponentsNew = new List<RepeaterComponentWrapper>();
        List<List<RepeaterComponentWrapper>> wrappedComponentsNewList = new List<List<RepeaterComponentWrapper>>();
        Set<Id> elementIds = new Set<Id>();
            for (Form__c record : [SELECT 
                                            (Select Element__c, Form__c From Form_Elements__r)
                                            FROM Form__c
                                            WHERE Name = :groupName])
            {
                for (Form_Element__c child : record.Form_Elements__r)
                {
                    elementIds.add(child.Element__c);
                }
            }
        
        
        // Element__c Lightning_Element__r.name instead of this use new field Lightning_Element_Name__c
        //Lightning_Element_Name__c this field data will be coming through Lightning_Element_Detail__mdt->Lightning_Component_Name__c
        //Element_Attributes__r Lightning_Attribute__r.name instead of this use new field Lightning_Attribute_Name__c
        //Lightning_Attribute_Name__c this field data will be coming through Lightning_Attribute_Detail__mdt-> Lightning_Component_Attribute_Name__c
            for (Element__c record : [Select Element__r.name,Element__r.Label__c,/*Element__c Lightning_Element__r.name*/Lightning_Component_Name__c ,
                                        (Select /*Lightning_Attribute__r.name*/Lightning_Attribute_Name__c ,Value__c From Element_Attributes__r) 
                                        From Element__c where id in :elementIds])
            {
                //element detail prepare start from here
                Map<String, Object> attributes = new Map<String, Object>();
                for (Element_Attribute__c child : record.Element_Attributes__r)
                {   
                    if(String.isNotEmpty(child.Value__c)){
                        putAttribute(attributes, child.Lightning_Attribute_Name__c, 'String', child.Value__c);
                    }                    
                }                
                RepeaterComponentWrapper.RepeaterCard rc = new RepeaterComponentWrapper.RepeaterCard();
                rc.name = record.Lightning_Component_Name__c;   
                RepeaterComponentWrapper rcw = new RepeaterComponentWrapper();
                //element prepared with attribute infomation end here
                rcw.sections.add(new RepeaterComponentWrapper(rc, attributes));
                System.debug('Label::'+record.Element__r.Label__c);
                rcw.label = record.Element__r.Label__c;
                wrappedComponentsNew.add(rcw);                
            }
            wrappedComponentsNewList.add(wrappedComponentsNew);
        return wrappedComponentsNew;
    }
    public static List<RepeaterComponentWrapper> getComponentsByGroupNameNewRecursivecall(String groupName) {
        List<RepeaterComponentWrapper> wrappedComponentsNew = new List<RepeaterComponentWrapper>();
        List<List<RepeaterComponentWrapper>> wrappedComponentsNewList = new List<List<RepeaterComponentWrapper>>();
        Set<Id> elementIds = new Set<Id>();
            for (Form__c record : [SELECT 
                                            (Select Element__c, Form__c From Form_Elements__r)
                                            FROM Form__c
                                            WHERE Name = :groupName])
            {
                for (Form_Element__c child : record.Form_Elements__r)
                {
                    elementIds.add(child.Element__c);
                }
            }
        
        
       	wrappedComponentsNew = preparedParentElementnew(elementIds);
        return wrappedComponentsNew;
    }
    
    public static List<RepeaterComponentWrapper> preparedParentElementnew(Set<Id> elementIds){
       List<RepeaterComponentWrapper> wrappedComponentsNew = new List<RepeaterComponentWrapper>();
        for (Element__c record : [Select Label__c,Element__r.Id,Element__r.name,/*Element__c Lightning_Element__r.name*/Lightning_Component_Name__c ,
                                        (Select /*Lightning_Attribute__r.name*/Lightning_Attribute_Name__c ,Value__c From Element_Attributes__r) 
                                        From Element__c where id in:elementIds])
        {
            RepeaterComponentWrapper rcwa = new RepeaterComponentWrapper();            
            rcwa = preparedParentElementnew1(record,rcwa);
            wrappedComponentsNew.add(rcwa);
            
        }
        return wrappedComponentsNew;
    }
     //below method needs to be refactored as per the SOQL, need to add the map of map
     public static RepeaterComponentWrapper preparedParentElementnew1(Element__c record,RepeaterComponentWrapper rcwa){
         if(record.Element__r.Id != null){
                    Set<Id> elementId = new Set<Id>();
                    elementId.add(record.Element__r.Id);
                    RepeaterComponentWrapper rcNew = new RepeaterComponentWrapper();
                        Map<String, Object> attributes = new Map<String, Object>();
                        //if the parent section is label it will not have any element attributes in it.
                        for (Element_Attribute__c child : record.Element_Attributes__r)
                        {   
                            if(String.isNotEmpty(child.Value__c)){
                                putAttribute(attributes, child.Lightning_Attribute_Name__c, 'String', child.Value__c);
                            }                    
                        }                
                        //below code will prepared section.
                        RepeaterComponentWrapper.RepeaterCard rc = new RepeaterComponentWrapper.RepeaterCard();
                        rc.name = record.Lightning_Component_Name__c;  
                        rcwa.component = rc;
                        rcwa.attributes = attributes;
                        rcwa.Label = record.Label__c;
                    rcNew.sections.add(rcwa);
                    rcwa = preparedParentElement(elementId,rcwa.sections,rcNew);//return the child sections                   
                    
                }else{
                    //element detail prepare start from here
                    Map<String, Object> attributes = new Map<String, Object>();
                    //if the parent section is label it will not have any element attributes in it.
                    for (Element_Attribute__c child : record.Element_Attributes__r)
                    {   
                        if(String.isNotEmpty(child.Value__c)){
                            putAttribute(attributes, child.Lightning_Attribute_Name__c, 'String', child.Value__c);
                        }                    
                    }                
                    //below code will prepared section.
                    RepeaterComponentWrapper.RepeaterCard rc = new RepeaterComponentWrapper.RepeaterCard();
                    rc.name = record.Lightning_Component_Name__c;                      
                    rcwa.Label = record.Label__c;                   
                }
                return rcwa;
     }
    /**
    * @Author Incapsulate
    * @Since 10-04-2019
    * @Description: Below method will be used to identify the section parent info or will be used in recursive call. 
    */
    public static RepeaterComponentWrapper preparedParentElement(Set<Id> elementIds,List<RepeaterComponentWrapper> wrappedComponentsNew,RepeaterComponentWrapper rcwa){
        for (Element__c record : [Select Label__c,Element__r.Id,Element__r.name,/*Element__c Lightning_Element__r.name*/Lightning_Component_Name__c ,
                                        (Select /*Lightning_Attribute__r.name*/Lightning_Attribute_Name__c ,Value__c From Element_Attributes__r) 
                                        From Element__c where id in:elementIds])
            {
                if(record.Element__r.Id != null){
                    Set<Id> elementId = new Set<Id>();
                    elementId.add(record.Element__r.Id);
                    RepeaterComponentWrapper rcNew = new RepeaterComponentWrapper();
                        Map<String, Object> attributes = new Map<String, Object>();
                        //if the parent section is label it will not have any element attributes in it.
                        for (Element_Attribute__c child : record.Element_Attributes__r)
                        {   
                            if(String.isNotEmpty(child.Value__c)){
                                putAttribute(attributes, child.Lightning_Attribute_Name__c, 'String', child.Value__c);
                            }                    
                        }                
                        //below code will prepared section.
                        RepeaterComponentWrapper.RepeaterCard rc = new RepeaterComponentWrapper.RepeaterCard();
                        rc.name = record.Lightning_Component_Name__c;  
                        rcwa.component = rc;
                        rcwa.attributes = attributes;
                        rcwa.Label = record.Label__c;
                    rcNew.sections.add(rcwa);
                    rcwa = preparedParentElement(elementId,rcwa.sections,rcNew);//return the child sections                   
                    
                }else{
                    //element detail prepare start from here
                    Map<String, Object> attributes = new Map<String, Object>();
                    //if the parent section is label it will not have any element attributes in it.
                    for (Element_Attribute__c child : record.Element_Attributes__r)
                    {   
                        if(String.isNotEmpty(child.Value__c)){
                            putAttribute(attributes, child.Lightning_Attribute_Name__c, 'String', child.Value__c);
                        }                    
                    }                
                    //below code will prepared section.
                    RepeaterComponentWrapper.RepeaterCard rc = new RepeaterComponentWrapper.RepeaterCard();
                    rc.name = record.Lightning_Component_Name__c;                      
                    rcwa.Label = record.Label__c;                   
                }
                
              
                //element prepared with attribute infomation end here
                
                                
            }
          
        return rcwa;
    }
    
     private static void putAttribute(Map<String, Object> attributes, String attrName, String attrType, String attrValue) {
        if(String.isNotBlank(attrName)) {
            Object value = null;
            try{
                switch on attrType {
                    when 'Number' { value = JSON.deserializeUntyped(attrValue); }
                    when 'Checkbox' { value = JSON.deserializeUntyped(attrValue); }
                    when 'JSON' { value = JSON.deserializeUntyped(attrValue); }
                    when else { value = attrValue; }
                }
            }
            catch(Exception ex) {
                System.debug('Unable to get value for attribute: ' + attrName);
            }
            attributes.put(attrName, value);
        }
    }
    /**
    * @Author Incapsulate
    * @Since 12-03-2019
    * @Description: 
    */
    public static Map<String,Object> getSobjectJson(String groupName,String recordId,Boolean childQuery){
        Map<String,String> parentChild = new Map<String,String>();
        Map<String,String> returnMap = new Map<String,String>();
        String parentObjectType = '';
        String childObjectType='';
        String subColumnNames = '';
        String col = getDetailSobjectJson(groupName,recordId,childQuery,parentChild,parentObjectType,childObjectType,subColumnNames);
        String query = '';
        String buildChildQuery = '';
        String childObjectApi = '';
        List<String> childObjectApiList = new List<String>();
        String parentObjectName = '';
        List<String> buildChildQueries = new List<String>();
        for(String objectName : parentChild.keySet()){
            if(objectName.contains('child$$')){
                String objectapi = objectName.split('\\$\\$')[1];
                childObjectApi = objectapi;
                if(objectapi.contains('__')){
                   objectapi = objectapi.split('__')[0]+'s__c';
                }else{                    
                    if(objectapi.endsWith('y')){
                        objectapi = objectapi.removeEnd('y')+'ies';
                    }else if(objectapi.endsWith('Y')){
                        objectapi = objectapi.removeEnd('Y')+'ies';
                    }else{
                        objectapi = objectapi+'s';
                    }
                }
                childObjectApiList.add(objectapi);
                String childcol = parentChild.get(objectName);
                String actulcol = actulColums(objectName,childcol,parentChild,childObjectApi);
                buildChildQuery = '(Select '+ actulcol +' From '+objectapi+')';     
                buildChildQueries.add(buildChildQuery);
            }else if(objectName.contains('parent$$')){
                parentObjectName = objectName.split('\\$\\$')[1]+'';
                String childcol = parentChild.get(objectName);
                String actulcol = actulColums(objectName,childcol,parentChild,parentObjectName);
                query = 'Select '+ actulcol;// +' sub_query_to_replace From '+objectName.split('\\$\\$')[1]+'';
                
                //query = 'Select id sub_query_to_replace From '+objectName.split('\\$\\$')[1]+'';
            }
        }
        Id recID = (Id)recordId;
        for(String buildChild : buildChildQueries){
            query = query + ' ,'+buildChild;
        }
        
        query = query + ' From '+parentObjectName+' where id = :recordId';
        List<sobject> listAcc = Database.query(query);
        String jsonStr = JSON.serialize(listAcc[0]);
        Map<String,Object> jsonobj =(Map<String,Object>)JSON.deserializeUntyped(jsonStr);
        for(String key: jsonobj.keySet()){
            if(childObjectApiList.contains(key)){
                Map<String,Object> childRecord = (Map<String,Object>)jsonobj.get(key);
                for(String keyrec: childRecord.keySet()){
                    if(keyrec == 'records'){
                        Map<String,Object> recordMap = new Map<String,Object>();
                        List<Object> lstobj = (List<Object>)childRecord.get(keyrec); 
                        for(Integer i=0;i<lstobj.size();){
                            recordMap.put(''+i,lstobj[i]);
                            Map<String,Object> childobj = (Map<String,Object>) lstobj[i];
                            Map<String,Object> attribute = (Map<String,Object>)childobj.get('attributes');
                            childObjectApi = (String)attribute.get('type');
                            i++;
                        }
                        returnMap.put('relatedsObject_'+childObjectApi,JSON.serialize(recordMap));
                        jsonobj.put('relatedsObject_'+childObjectApi,recordMap);
                        //System.debug('>>obj>>'+lstobj);                        
                    }
                }
                jsonobj.remove(key);
            }
        }
        return jsonobj;
    }
    
    /**
    * @Author Incapsulate
    * @Since 12-03-2019
    * @Description: 
    */
    public static String getDetailSobjectJson(String groupName,String recordId,Boolean childQuery,Map<String,String> parentChild,String parentObjectType,String childObjectType,String subColumnNames){
            List<String> groupNames = groupName.split(',');
            System.debug('groupNames>>>>'+groupNames);
            Set<Id> elementIds = new Set<Id>();
            String columnNames = '';
            String parentFieldName = '';   
            
            for (Form__c record : [SELECT sObject_API_Name__c   ,
                                            (Select Element__c, Form__c From Form_Elements__r)
                                            FROM Form__c
                                            WHERE Name in :groupNames])
            {
                if(String.isEmpty(parentObjectType)){
                    parentObjectType = record.sObject_API_Name__c;
                }
                for (Form_Element__c child : record.Form_Elements__r)
                {
                    elementIds.add(child.Element__c);
                }
            }
            
            for (Element__c record : [Select Lightning_Component_Name__c ,
                                        (Select Lightning_Attribute_Name__c ,Value__c From Element_Attributes__r) 
                                        From Element__c where id in :elementIds])
            {
                
                Map<String, Object> attributes = new Map<String, Object>();
                for (Element_Attribute__c child : record.Element_Attributes__r)
                {   
                    //System.debug('child:::'+child+'::::-->'+record.Lightning_Component_Name__c);
                    if(record.Lightning_Component_Name__c == 'INLA:repeater'){
                       // System.debug('child:::'+child+'::::-->'+child.Lightning_Attribute_Name__c);
                        /*if(child.Lightning_Attribute_Name__c == 'fieldBinding'){
                            subColumnNames = subColumnNames + child.Value__c +',';
                        } */
                        if(child.Lightning_Attribute_Name__c == 'parentFieldName' && String.isNotEmpty(child.Value__c)){
                           // System.debug('>>subColumnNames.lastIndexOf>>'+subColumnNames.lastIndexOf(','));
                            //System.debug('>>subColumnNames.lastIndexOf>>'+subColumnNames);
                            parentFieldName = child.Value__c;
                            /*if(subColumnNames.endsWith(',')){
                                subColumnNames = subColumnNames+child.Value__c;    
                            }else{
                                subColumnNames = subColumnNames+','+child.Value__c;    
                            }  */                          
                        }else if(child.Lightning_Attribute_Name__c == 'objectType' && String.isNotEmpty(child.Value__c)){
                            childObjectType = child.Value__c;
                        }else if(child.Lightning_Attribute_Name__c == 'groupName'){
                            if(String.isNotEmpty(parentFieldName)){
                                //subColumnNames = subColumnNames + parentFieldName;
                                String childCol = '';
                                childCol = getDetailSobjectJson(child.Value__c,null,true,parentChild,parentObjectType,childObjectType,'');
                                //System.debug('>>>'+childCol);
                                //System.debug('>subColumnNames>>'+subColumnNames);
                                subColumnNames = childCol+','+parentFieldName;
                            }else{
                                //System.debug('>else subColumnNames>>'+subColumnNames);
                                subColumnNames = getDetailSobjectJson(child.Value__c,null,true,parentChild,parentObjectType,childObjectType,'');
                                //System.debug('>2subColumnNames>>'+subColumnNames);
                            }
                            
                            //System.debug('>>>>>>subColumnNames>>>>>>>>'+subColumnNames);                            
                        }
                       // 
                       
                        subColumnNames = subColumnNames.removeEnd(',');
                        if(String.isNotEmpty(childObjectType)){
                            parentChild.put('child$$'+childObjectType,subColumnNames);
                        }
                        
                    }else if(child.Lightning_Attribute_Name__c == 'fieldBinding' && String.isNotEmpty(child.Value__c)){
                        columnNames = columnNames + child.Value__c +',';
                    }
                }                
                //RepeaterComponentWrapper.RepeaterCard rc = new RepeaterComponentWrapper.RepeaterCard();
                //rc.name = record.Lightning_Component_Name__c;                
                //wrappedComponentsNew.add(new RepeaterComponentWrapper(rc, attributes));                
            }
            columnNames = columnNames.removeEnd(',');
            parentChild.put('parent$$'+parentObjectType,columnNames);  
        //if(!childQuery)
        //  System.debug('<<parentChild>>>'+parentChild);
        return columnNames;
    }
    
    
    /**
    * @Author Incapsulate
    * @Since 28-03-2019
    * @Description: 
    */
    public static Map<String, Object> saveUpdateForm(List<String> jsonInput,Boolean isReturnMapOfId){
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
                    jsonMap.remove(fieldName);
                    
                }                
            }
            
            sObject parentSobj = getSobject(jsonMap,JSON.serialize(jsonMap));
            upsert parentSobj;
            listOfId.add((ID)parentSobj.id);            
            jsonMapClone.put('id',parentSobj.id);
            if(parentSobj != null && parentSobj.id != null)
            for (String fieldName : jsonMapClone.keySet()){                 
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
            List<List<sObject>> listOfSobjectToInsert = new List<List<sObject>>();
            List<sObject> listToUpdate = new List<sObject>();
            List<sObject> listToDelete = new List<sObject>();
            /**
             * 
             * belwo DML inside the for loop will not exceed the limitation
             * because i am preparing the list of list<sobject> for related objects
             * and one parent will not have more related objects max to 10-20
             * 
             */
            //Map<Integer, sObject> sobjMap = new Map<Integer, sObject>();
            //Integer i =0;
            if(!relatedsObjectList.isEmpty()){
                for(List<sObject> lstSobject: relatedsObjectList){
                    for(sObject obj: lstSobject){
                        if(obj.ID != null){
                            listToUpdate.add(obj);
                        }else if(obj.ID == null){
                           listToInsert.add(obj);
                           //sobjMap.put(i, obj);
                        }
                    }
                    //insert lstSobject;
                    listOfSobjectToInsert.add(listToInsert);
                }                
            }            
            if(!listToUpdate.isEmpty()){
                update listToUpdate;
            }
            if(isReturnMapOfId){
                if(!listToInsert.isEmpty()){
                    insert listToInsert;
                }
                jsonMapClone.put('FlowResponse',listOfId);
            }else{
            //below for loop is using each sObject list like related contact,
            //related opportunities etc. so inside for loop the max related object will not exceed the
            //DML limit
            for(List<sObject> lstToinsert : listOfSobjectToInsert){
                insert lstToinsert;
                for(sObject sobj:lstToinsert){
                        String relatesobjectType = 'relatedsObject_'+sobj.getSObjectType();
                        if(parentSobj != null && parentSobj.id != null){
                            String jsonString = JSON.serialize(jsonMapClone.get(relatesobjectType));
                            Map<String, Object> relatedJsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                            for (String keyIndex : relatedJsonMap.keySet()){
                                String jsonSubString = JSON.serialize(relatedJsonMap.get(keyIndex));
                                Map<String, Object> subObjJsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonSubString);
                                subObjJsonMap.put('Id',sobj.id);
                                for (String relatedFieldNameRef : subObjJsonMap.keySet()){
                                    String fieldvalue = String.valueOf(subObjJsonMap.get(relatedFieldNameRef));
                                    if(fieldvalue == 'parentFieldId'){
                                        subObjJsonMap.put(relatedFieldNameRef,(ID)parentSobj.id);
                                    }
                                }
                                relatedJsonMap.put(keyIndex,subObjJsonMap);
                            }
                            jsonMapClone.put(relatesobjectType,relatedJsonMap);
                        }                    
                }
            }
            }
           
        }catch(Exception ex){
            System.debug('Error occured while upsert:'+ex.getMessage());
            System.debug('Error occured while upsert:'+ex.getStackTraceString());
        }        
        return jsonMapClone;
    }
     
    
    public class Attributes{
        String type;
        String url;
    }
    
    private static sObject getSobject(Map<String, Object> jsonMap,String jsonSobject){
        String jsonAttribute = JSON.serialize(jsonMap.get('attributes'));
            Attributes att  = (Attributes) JSON.deserialize(jsonAttribute,Attributes.class);
            String objectName = att.type;
            Type theClass = Type.forName(ObjectName);
            sObject objInstance = (SObject)JSON.deserialize(jsonSobject,theClass);
        return objInstance;
    }
    
    private static String actulColums(String objectName,String childcolums,Map<String,String> parentChild,String objectapi){
        		Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
				Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objectapi).getDescribe().fields.getMap();
                //childcolums = parentChild.get(objectName);
                List<String> childColumsList = childcolums.split(',');
                Integer index = 0;
                for(Integer i=0;i< childColumsList.size();i++){
                    index = index+1;
                    if(fieldMap.get(childColumsList[i]) == null && childColumsList.contains(childColumsList[i])){
                        childColumsList.remove(i);
                    }    
                }
                childcolums = string.join(childColumsList,',');
        
        return childcolums;
    }

    
}