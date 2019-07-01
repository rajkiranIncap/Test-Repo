/**
 * Since:  01/02/2019
 * Author: Incapsulate
 * Generalizing the dependent component function as required based on attributes.
*/
({
    init: function (component, event, helper) {
        if(component.getSuper() && component.getSuper().find("incapLightningInputEl")){
            helper.setDefaultValueOfElementProperty(component, event, "readonly",component.get("v.readonly"),"string");
            helper.setDefaultValueOfElementProperty(component, event, "disabled",component.get("v.disabled"),"string");
            helper.setDefaultValueOfElementProperty(component, event, "required",component.get("v.required"),"string");
            helper.setDefaultValueOfElementProperty(component, event, "pattern",component.get("v.pattern"),"string");
        }
        
    },
    handleApplicationEvent : function(component, event, helper){
        if(event.getParam("fieldValueObject").dependsOnValue){
            var valueId = "dependsOnValue";
            var inputValue = event.getParam("fieldValueObject").dependsOnValue.toString();    
            if(event.getParam("fieldValueObject").dependsOnValue instanceof Array){
                inputValue = event.getParam("fieldValueObject").dependsOnValue;                
            }                
            if(component.get("v."+valueId)){
                helper.skipLogic(component, event,"dependsOnValue",inputValue,"isDependsOnValueRegex","isRender");
            }
            
            valueId = "dependsOnHideValue";
            if(component.get("v."+valueId)){
                helper.skipLogic(component, event,"dependsOnHideValue",inputValue,"isDependsOnHideValueRegex","isRender","hide");
            }
            
            valueId = "isRequiredOnValue";
            if(component.get("v."+valueId)){
                helper.skipLogic(component, event,"isRequiredOnValue",inputValue,"isRequiredOnValueRegex","required");
            }
            
            valueId = "isDisabledOnValue";
            if(component.get("v."+valueId)){
                helper.skipLogic(component, event,"isDisabledOnValue",inputValue,"isDisabledOnValueRegex","disabled");
            }
        }
    },
    handleApplicationValidateComponent : function(component, event, helper){
        console.log('handleApplicationValidateComponent::')
        if(event.getParam("calledForCount") && (event.getParam("calledForValidation")==false && !event.getParam("calledForValidation"))){
            var appSyncEvent = $A.get("e.c:eventToCountComponent");
            appSyncEvent.setParams({
                "count": 1,
                "calledForValidation" : false
            });
            appSyncEvent.fire();
        }
        else if(event.getParam("isValid") && event.getParam("calledForValidation")) {
            var appSyncEvent = $A.get("e.c:eventToCountComponent");
            appSyncEvent.setParams({
                "isValid": component.getSuper().find("incapLightningInputEl") ? component.getSuper().find("incapLightningInputEl").reportValidity() : true,
                "calledForValidation" : true
            });
            appSyncEvent.fire();
        }
        
    }
})