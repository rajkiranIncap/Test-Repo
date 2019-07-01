({
    doInit : function(component, event, helper) { 
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        var objectName = component.get("v.objectApiName");
        
        var isDepedentBasedOnSobjects = component.get("v.isDepedentBasedOnSobjects");
        var controllingSobjectAPI = component.get("v.controllingSobjectAPI");
        var dependentSobjectAPI = component.get("v.dependentSobjectAPI");
       
        helper.fetchPicklistValues(component,objectName,objDetails,controllingFieldAPI, dependingFieldAPI,
                                  isDepedentBasedOnSobjects,controllingSobjectAPI,dependentSobjectAPI);
        //NOTE: Below code may required in ILA or need to refactored to dynamically create the picklist and bind the field as well
        /*if(!component.get("v.objDetail")){
            var objattributes = {attributes:{type: component.get("v.objectApiName"), url:"/services/data/v45.0/sobjects/"+component.get("v.objectApiName") }};
            component.set("v.objDetail",objattributes); 
        }
        var controler = component.find("controllfield");
        var dependent = component.find("dependentfield");
        controler.set("v.value",component.getReference('v.objDetail.'+controllingFieldAPI));
        dependent.set("v.value",component.getReference('v.objDetail.'+dependingFieldAPI));*/
        
        
        /*component.set('v.validate', function() {    
             	//component.set("v.value", JSON.stringify(value));
             component.set("v.controlfieldvalue",component.get("v.controlfieldvalue"));
             component.set("v.dependentfieldvalue",component.get("v.dependentfieldvalue"));
            	return { 
                      isValid: true, 
                      errorMessage: '' 
                  }; 
              });*/
        
    },
    
    onControllerFieldChange: function(component, event, helper) {     
        /*if(event.getParam("dependentObject") && event.getParam("dependentObject").dependentValue){
				component.set("v.dependentfieldvalue",event.getParam("dependentObject").dependentValue);            
        }else{*/
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        helper.onchageofcontrolingfield(component, controllerValueKey);
        /*var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        if(controllerValueKey || controllerValueKey==""){
            component.set("v.controlfieldvalue",controllerValueKey);
            var depnedentFieldMap = component.get("v.depnedentFieldMap");
            
            if (controllerValueKey != '') {
                var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
                
                if(ListOfDependentFields.length > 0){
                    component.set("v.bDisabledDependentFld" , false);  
                    helper.fetchDepValues(component, ListOfDependentFields);    
                }else{
                    component.set("v.bDisabledDependentFld" , true); 
                    component.set("v.listDependingValues", []);
                }  
                
            } else {
                var ListOfDependentFields = [];
                helper.fetchDepValues(component, ListOfDependentFields);
                component.set("v.bDisabledDependentFld" , true);
            }
        }*/
        //}
    },
})