({
    init: function (component, event, helper) {
        let type = component.get("v.type")
        if(type)
        component.set("v.type", type.toLowerCase());
		var colint = component.get("v.columns");
        if(colint)
		component.set("v.columnsInt",parseInt(colint));        
    },
    //<!-- 07/02/2019 Incapsulate Added function for depedent skip logic-->
    onInputChange : function(component, event, helper){ 
        var readonlyinput = component.get("v.disabled") || component.get("v.readonly");
        if(!readonlyinput){
            var value = event.getSource().get("v.value");   
            if(component.get("v.dependencyId")){
                var appEvent = $A.get("e.c:onChangeApplicationEvent");
                appEvent.setParams({
                    "fieldValueObject":{
                        "dependencyId" : component.get("v.dependencyId"),
                        "dependsOnId" : component.get("v.dependsOnId"),
                        "dependsOnValue" : value
                    }
                });
                appEvent.fire();
            } 
            
            var appSyncEvent = $A.get("e.c:eventToSyncSobject");
            appSyncEvent.setParams({
                "FormDetailObject":{
                    "relatedSobject" : component.get("v.genericObjectValue"),//repeaterCardController line 26
                    "indexVal" : component.get("v.indexVal"),
                    "parentFieldName" : component.get("v.parentFieldName"),
                    "validityKey" : event.getSource().get("v.name"),
                    "validityValue" : component.find("incapLightningInputEl").reportValidity()
                }
            });
            appSyncEvent.fire();   
            //below component event is handled in formTable.cmp only which is a parent ot this component.
            //while dynamicaly rendering the component.
            //wherever required use component event inside of application event.
            //so that only the parent component will handle this as required.
            var compEvent = component.getEvent("calculateValues");
            compEvent.setParams({"FormTableDetailObject":{
                "isReadOnly" : false}});
            compEvent.fire();
        }else{
            //below component event is handled in formTable.cmp
            var compEvent = component.getEvent("calculateValues");
            compEvent.setParams({"FormTableDetailObject":{
                "isReadOnly" : true}
                                });
            compEvent.fire();
        }
    },
    onBlurValidate  : function(component, event, helper){  
        var appSyncEvent = $A.get("e.c:eventToSyncSobject");
        appSyncEvent.setParams({
            "FormDetailObject":{
                "validityKey" : event.getSource().get("v.name"),
                "validityValue" : component.find("incapLightningInputEl").reportValidity()
            }
        });
        appSyncEvent.fire();
    },
    
    handleValidation: function(component, event, helper){  
        console.log("handleValidation");
        var appSyncEvent = $A.get("e.c:eventToSyncSobject");
        appSyncEvent.setParams({
            "FormDetailObject":{
                "validityKey" : component.find("incapLightningInputEl").get("v.name"),
                "validityValue" : component.find("incapLightningInputEl").reportValidity(),
                "calledFromInputFSC" : true
            }
        });
        appSyncEvent.fire();
    }
})