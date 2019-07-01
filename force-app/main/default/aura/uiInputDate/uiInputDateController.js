({
    
    validatedate : function(component, event, helper) {
        var datecmp = component.find("uiInputDate");
        var dateval = component.get("v.valueDate");
        if(!dateval){
            dateval = component.get("v.value");
        }
        if(dateval){
            var errormsg = component.get("v.errorMsg");
            var dateobj = new Date(dateval);
            if(dateobj.toString() =="Invalid Date"){
                datecmp.set("v.errors", [{message:errormsg+" "+component.get("v.format")}]);
            }else{
                datecmp.set("v.errors", null);            
            }
        }
    },handleApplicationEvent : function(component, event, helper){
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
})