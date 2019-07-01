/**
 * Since:  01/02/2019
 * Author: Incapsulate
 * Generalizing the depedent component function as required based on attributes.
*/
({
    handleApplicationEvent : function(component, event, helper){
        if(event.getParam("fieldValueObject").dependsOnValue){
            var valueId = "dependsOnValue";
            var inputValue = event.getParam("fieldValueObject").dependsOnValue.toString();    
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
    }    
})