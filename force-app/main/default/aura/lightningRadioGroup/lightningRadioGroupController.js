({
	init : function(component, event, helper) {
        if(component.get("v.valueAsBoolean")){
            var stringValue = component.get("v.value");
            var boolValue = JSON.parse(stringValue);
            component.set("v.valueAsBoolean",boolValue);
            component.set("v.value",boolValue);
        }else if(component.get("v.value")){
            var stringValue = component.get("v.value");
            //var boolValue = JSON.parse(stringValue);
            //component.set("v.valueAsBoolean",boolValue);
            //component.set("v.value",""+boolValue);
            try{
            	stringValue = JSON.parse(stringValue);
                component.set("v.valueAsBoolean",stringValue);
                //stringValue = boo
            }catch(err){
                
            }
            //component.set("v.valueAsBoolean",boolValue);
            component.set("v.value",stringValue);
        }
        var objstr =""+component.get("v.optionsJson");
		var obj = JSON.parse(objstr);
        component.set("v.options",obj);
	},
    handleChange: function (component, event,helper) {
        if(component.get("v.valueAsBoolean")){
            var stringValue = component.get("v.value");
			var boolValue = JSON.parse(stringValue);
            component.set("v.valueAsBoolean",boolValue);
            component.set("v.value",boolValue);
        }else if(component.get("v.value")){
            var stringValue = component.get("v.value");
            try{
            	stringValue = JSON.parse(stringValue);
                component.set("v.valueAsBoolean",stringValue);
                //stringValue = boo
            }catch(err){
                
            }
            //component.set("v.valueAsBoolean",boolValue);
            component.set("v.value",stringValue);
        }
        helper.onInputChange(component, event);
    },
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