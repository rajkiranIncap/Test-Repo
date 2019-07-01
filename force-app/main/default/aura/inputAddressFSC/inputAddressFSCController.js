({
    myAction : function(component, event, helper) {
		component.sampleMethod();
    }, onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.country"); // get selected controller field value
        if(controllerValueKey || controllerValueKey == ""){
            component.set("v.controlfieldvalue",controllerValueKey);
            component.set("v.country",controllerValueKey);
            var depnedentFieldMap = component.get("v.depnedentFieldMap");
            
            if (controllerValueKey != '') {
                var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
                
                if(ListOfDependentFields.length > 0){
                    //component.set("v.bDisabledDependentFld" , false);  
                    helper.fetchDepValues(component, ListOfDependentFields);    
                }else{
                    //component.set("v.bDisabledDependentFld" , true); 
                    component.set("v.listDependingValues", []);
                }  
                
            } else {
                var ListOfDependentFields = [];
                helper.fetchDepValues(component, ListOfDependentFields);
                //component.set("v.bDisabledDependentFld" , true);
            }
        }
        //}
    },
    onStateFieldChange : function(component, event, helper) {     
        var stateValueKey = event.getSource().get("v.province"); // get selected controller field value
        if(stateValueKey || stateValueKey == ""){
            component.set("v.province",stateValueKey);
        }
    },
})