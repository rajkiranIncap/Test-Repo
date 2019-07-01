({
	init : function(component, event, helper) {
        var objstr =""+component.get("v.optionsJson");
		var obj = JSON.parse(objstr);
        component.set("v.options",obj);
	},
    /**
     * Modified Since:  03/06/2019
     * Author: Incapsulate
     * 
    */
    handleChange: function (component, event,helper) {
        var readonlyinput = component.get("v.disabled") || component.get("v.readonly");
            var valueList = event.getSource().get("v.value");
            var value = "";    
            if(valueList){
                for(var i=0;i<valueList.length;i++){
                    if(i<valueList.length)
                    	value = value + valueList[i]+";";
                    else if(i==valueList.length){
                        value = value + valueList[i];
                    }
                }
             }
            var s = value;
            var withoutLastComma = s.slice(0, s.lastIndexOf(";"));
        	component.set("v.value",withoutLastComma);
            if(component.get("v.dependencyId")){
                var appEvent = $A.get("e.c:onChangeApplicationEvent");
                appEvent.setParams({
                    "fieldValueObject":{
                        "dependencyId" : component.get("v.dependencyId"),
                        "dependsOnId" : component.get("v.dependsOnId"),
                        "dependsOnValue" : valueList
                    }
                });
                appEvent.fire();
            } 
    }
})