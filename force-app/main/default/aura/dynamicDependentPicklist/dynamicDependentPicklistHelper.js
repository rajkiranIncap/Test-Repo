({
    fetchPicklistValues: function(component,objectName,objDetails,controllerField, dependentField,                                 
                                  isDepedentBasedOnSobjects,controllingSobjectAPI,dependentSobjectAPI) {
        // call the server side function  
        var action = component.get("c.getDependentMapFromSobjectOrDependentpicklist");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'isDepedentBasedOnSobjects':isDepedentBasedOnSobjects,
            'objectName' : objectName,            
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField,
            'controllingSobjectAPI':controllingSobjectAPI,
            'dependentSobjectAPI':dependentSobjectAPI
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    var obj = {};
                    obj.label = singlekey;
                    obj.value = singlekey;
                    listOfkeys.push(obj);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push({label:'--None--',value:''});
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);
                if(component.get("v.controlfieldvalue") != ""){
                    this.onchageofcontrolingfield(component, component.get("v.controlfieldvalue"));
                }
                //Below code to dynamically create the picklist and bind the field as well
                /* if(!component.get("v.objDetail")){
                    var objattributes = {attributes:{type: component.get("v.objectApiName"), url:"/services/data/v45.0/sobjects/"+component.get("v.objectApiName") }};
                   component.set("v.objDetail",objattributes); 
                }
                var listToCreate = [];
                    var controllingcomponent =                           
                    ["c:lightningSelectComponent",
                            {
                                "name":"controllerFld",
                                "label":"Country",
                                "value": component.getReference('v.objDetail.'+controllerField),
                                "options": ControllerField,
                                "isControllingField": true,
                                "onchangefunctionvalue":""
                    }];
                		listToCreate.push(controllingcomponent);
                        $A.createComponents(
                            listToCreate,
                            function(cmps, status, error){
                                if (status === "SUCCESS") {
                                    var components = component.get('v.components');
                                    if(!components) { components = []; }
                                    component.set('v.components', cmps);  
                                    // call the helper function                                    
                                    
                                }
                                else if (status === "INCOMPLETE") {
                                    console.log("No response from server or client is offline.")
                                }
                                    else if (status === "ERROR") {
                                        console.log(error);
                                    }
                            }
                        );
                		//while initializing the dependent component first time load
                        var ListOfDependentFields = [];
                        this.fetchDepValues(component, ListOfDependentFields);  */
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push({label:'--None--',value:''});
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        /*var listToCreate = [];
            var dependentcmp =                           
                        ["c:lightningSelectComponent",
                                {
                                    "name":"dependentFld",
                                    "label":"City",
                                    "value": component.getReference('v.objDetail.'+component.get("v.dependingFieldAPI")),
                                    "options": dependentFields,
                                    "isControllingField": false,
                                    "disabled" : dependentFields.length > 1 ? false : true,
                                    "onchangefunctionvalue":""
                        }];
                            listToCreate.push(dependentcmp);
                            $A.createComponents(
                                listToCreate,
                                function(cmps, status, error){
                                    if (status === "SUCCESS") {
                                        var components = component.get('v.childcomponents');
                                        if(!components) { components = []; }
                                        component.set('v.childcomponents', cmps);  
                                        // call the helper function                                 
                                        
                                    }
                                    else if (status === "INCOMPLETE") {
                                        console.log("No response from server or client is offline.")
                                    }
                                        else if (status === "ERROR") {
                                            console.log(error);
                                        }
                                }
                            );*/
        
        
    },
    onchageofcontrolingfield : function(component,controllerValueKey){
         
        if(controllerValueKey || controllerValueKey==""){
            component.set("v.controlfieldvalue",controllerValueKey);
            var depnedentFieldMap = component.get("v.depnedentFieldMap");
            
            if (controllerValueKey != '') {
                var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
                
                if(ListOfDependentFields.length > 0){
                    component.set("v.bDisabledDependentFld" , false);  
                    this.fetchDepValues(component, ListOfDependentFields);    
                }else{
                    component.set("v.bDisabledDependentFld" , true); 
                    component.set("v.listDependingValues", []);
                }  
                
            } else {
                var ListOfDependentFields = [];
                this.fetchDepValues(component, ListOfDependentFields);
                component.set("v.bDisabledDependentFld" , true);
            }
        }
    }
})