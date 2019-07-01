({
   handleApplicationEvent : function(component, event, helper){
       if(event.getParam("fieldValueObject")){
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