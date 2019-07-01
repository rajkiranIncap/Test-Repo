({
    doInit : function(component, event, helper) {
        
        //START ILA Lite
        var valueCloneStr = component.get("v.value");
       /* if(!valueCloneStr){
            console.log(component.get("v.value"));
            var valSr = component.get("v.value");
            if(valSr){
                component.set("v.value", valSr);
                component.set("v.objectVal", JSON.parse(valSr));
                valueCloneStr = component.get("v.objectVal");
            }*/
        //END ILA Lite
        component.set('v.validate', function() { 
            /*console.log(JSON.stringify(component.get("v.objectVal"))); //ILA Lite
            component.set("v.value", JSON.stringify(component.get("v.objectVal")));//ILA Lite
            component.set("v.objectVal", component.get("v.objectVal"));//ILA Lite
            var obj = JSON.parse(JSON.stringify(component.get('v.objectVal')))["relatedsObject_"+component.get("v.objectType")];
                        var objli = [];
                        objli["relatedsObject_"+component.get("v.objectType")] = obj;
            			component.set("v.objectValList",objli);*/
            return { 
                isValid: true, 
                errorMessage: '' 
            }; 
        });
        
        var action = component.get('c.getComponentsByGroupNameCustomMetadata');//without datamodel using custommetadata
        	//with datamodel
        	//component.get('c.getComponentsByGroupName'); 
        action.setParams({
            'groupName': component.get('v.groupName')
        });
        action.setCallback(this, function(response) {
            if(component.isValid()) {
                if(response.getState() === 'SUCCESS') {
                    var toCreate = response.getReturnValue();
                    component.set('v.toCreate', toCreate);
                    //component.set('v.objectVal',component.getReference('v.objectValList')[0]);
                    var objectType = component.get('v.objectType');
                    var recordTypeId = component.get('v.recordTypeId');
                    var parentId = component.get('v.parentId');
                    var parentField = component.get('v.parentField');;
                    var fields = [];
                    for(var index in toCreate) {
                        if(toCreate[index].attributes && toCreate[index].attributes.fieldBinding) {
                            fields.push(toCreate[index].attributes.fieldBinding);
                            // toCreate[index].attributes.objectVal = 
                            //attributes.cardIndex = index;
                        }
                    }                   
                    debugger;
                    var value = null;
                    if(component.get("v.objectValList") && component.get("v.objectValList").length >0){
                        value = component.get("v.objectValList"); //component.get("v.objectValList")[0]["relatedsObject_Contact"][1]
                    }
                    if(value) {
                        helper.addItems(component, value);
                    }
                }
                else {
                    console.log('Error while getting repeater metadata');
                }
            }
        });
        $A.enqueueAction(action);
        /*ILA LITE
         * }else {
            console.log(component.get("v.value"));
            var valSr = component.get("v.value");
            if(valSr){
                component.set("v.objectVal", JSON.parse(valSr));
            }
            var obj = JSON.parse(JSON.stringify(component.get('v.objectVal')))["relatedsObject_"+component.get("v.objectType")];
                        var objli = [];
                        objli["relatedsObject_"+component.get("v.objectType")] = obj;
            var lst = new Array();
            lst.push(objli);
            			component.set("v.objectValList",lst);
            var value = null;
            if(component.get("v.objectValList") && component.get("v.objectValList").length >0){
                        value = component.get("v.objectValList"); //component.get("v.objectValList")[0]["relatedsObject_Contact"][1]
                    }
                    if(value) {
                        helper.addItems(component, value);
                    }
        }*/
        
    },
    addClicked: function(component, event, helper) {
        helper.addItems(component,null);        
        //component.set("v.cardIndex", component.get("v.cardIndex")+1);
    },
    
    deleteClicked: function(component, event, helper) {
        component.set("v.isOpen",true);
        component.set("v.targetId",event.getSource().getGlobalId());
    },
    popUpHandler: function(component, event) { 
        //Get the event message attribute
        var confirm = event.getParam("confirmation"); 
        //Set the handler attributes based on event data 
        console.log("Confirmation-->"+confirm);
        if(confirm=="Yes"){
            debugger;
            //var targetId = event.getSource().getGlobalId();
            var targetId = component.get("v.targetId");
            var components = component.get('v.components');
            var newList = [];
            var deletedRecords = component.get('v.deletedRecords');
            var objectType = component.get('v.objectType');
            
            if(!deletedRecords) {
                deletedRecords = [];
            }
            for(var index in components) {
                if(components[index].getGlobalId() !== targetId) {
                    newList.push(components[index]);
                }
                else if(components[index].getValue) {
                    var record = components[index].getValue();
                    console.log('Record-->'+JSON.stringify(record));
                    var cardIndex = index;
                    if(record && record.Id) {
                        if(objectType) {
                            
                            record.SObjectType = objectType;
                            record.attributes = {
                                "type" : objectType
                            }
                            var action = component.get('c.deleteRecord');
                            action.setParams({
                                'recordId': record.Id,
                                'ObjectType': objectType
                            });
                            action.setCallback(this, function(response) {
                                if(component.isValid()) {
                                    if(response.getState() === 'SUCCESS') {
                                        console.log("cardIndex-->"+cardIndex);
                                       	//To sync Deleted record with the JSON
                                        
                                        var appSyncEvent = $A.get("e.c:eventToSyncSobject");
                                        appSyncEvent.setParams({
                                            "FormDetailObject":{
                                                "Sobject" : objectType,
                                                "index" : cardIndex
                                            }
                                        });
                                        appSyncEvent.fire();   
                                    }
                                }
                            });
                                               
                            $A.enqueueAction(action);
                        }
                        deletedRecords.push(record);
                    }
                    else{
                        var appSyncEvent = $A.get("e.c:eventToSyncSobject");
                        appSyncEvent.setParams({
                            "FormDetailObject":{
                                "Sobject" : objectType,
                                "index" : cardIndex
                            }
                        });
                        appSyncEvent.fire();
                    }
                }
            }
            component.set('v.components', newList);
            component.set('v.deletedRecords', deletedRecords)
        }
        
    },
    // below method is used in ILA Lite but can impact on form rendering , becuase of the below application event will be fired and handled in
    // formelements.cmp controller, if we use this application event here it will be fired twice in case of form rendering need to check the impact.
    // <aura:handler event="c:eventToSyncSobject" action="{!c.handleApplicationEventSync}" 
    // description="Application event fire after on change of the field value and execute the logic to get related object detail."/>    	
    handleApplicationEventSync : function(component, event, helper){
        //NOTE: below  condition works for ILA Lite but does not update the related records.
    	//for ILA form rendering, need to analysis. comment out this condition to check for ILA
          if(event.getParam("FormDetailObject") 
            && event.getParam("FormDetailObject").relatedSobject
           && event.getParam("FormDetailObject").relatedSobject.attributes
           && event.getParam("FormDetailObject").relatedSobject.attributes.type){
              
           var relatedSobject = event.getParam("FormDetailObject").relatedSobject;
         	var valueCloneContact = component.get("v.objectVal");
         	var listOfRelatedObject = valueCloneContact["relatedsObject_"+event.getParam("FormDetailObject").relatedSobject.attributes.type]
             if(!listOfRelatedObject){
                 
            	 valueCloneContact["relatedsObject_"+event.getParam("FormDetailObject").relatedSobject.attributes.type] = new Map();
                 var mymap = valueCloneContact["relatedsObject_"+event.getParam("FormDetailObject").relatedSobject.attributes.type];
                 if(event.getParam("FormDetailObject").relatedSobject && event.getParam("FormDetailObject").parentFieldName){
                     //valueCloneContact["parentFieldName"] = event.getParam("FormDetailObject").parentFieldName;
                     event.getParam("FormDetailObject").relatedSobject[event.getParam("FormDetailObject").parentFieldName] = "parentFieldId";
                 }
                 mymap[event.getParam("FormDetailObject").indexVal+""] = event.getParam("FormDetailObject").relatedSobject;  
                 
             }else{
                 
                 var mymap = valueCloneContact["relatedsObject_"+event.getParam("FormDetailObject").relatedSobject.attributes.type];
                 if(event.getParam("FormDetailObject").relatedSobject && event.getParam("FormDetailObject").parentFieldName){
                     //valueCloneContact["parentFieldName"] = event.getParam("FormDetailObject").parentFieldName;
                     event.getParam("FormDetailObject").relatedSobject[event.getParam("FormDetailObject").parentFieldName] = "parentFieldId";
                 }
                 mymap[event.getParam("FormDetailObject").indexVal+""] = event.getParam("FormDetailObject").relatedSobject;                   
             }
             //valueCloneContact[event.getParam("FormDetailObject").indexVal+1] = event.getParam("FormDetailObject").relatedSobject
         	 component.set("v.value", JSON.stringify(valueCloneContact));
             console.log("Inside SYNC valueCloneContact-->"+JSON.stringify(valueCloneContact));
             component.set("v.objectVal", valueCloneContact);
            
           /* 
            Old
         	var relatedSobject = event.getParam("FormDetailObject").relatedSobject;
            //var listOfRelatedObject = valueCloneContact["relatedsObject_"+event.getParam("FormDetailObject").type]
         	var objectval = component.get("v.objectVal");
            var mapofobjectval = component.get("v.mapOfObjectVal");
            mapofobjectval[event.getParam("FormDetailObject").indexVal+""] = event.getParam("FormDetailObject").relatedSobject;
         	component.set("v.value", JSON.stringify(mapofobjectval));
            component.set("v.objectVal", relatedSobject);          */
         }
     },
    
})