({
	myAction : function(component, event, helper) {
		var isControllingField = component.get("v.isControllingField");
        if(isControllingField){
            var cmpEvt = component.getEvent("onchangehandle");
            cmpEvt.fire();
        }else{
            var cmpEvt = component.getEvent("onchangehandle");
            cmpEvt.setParams({
                    "dependentObject":{
                        "dependentValue" : component.get("v.value")
                    }
                });
            cmpEvt.fire();
            
        }
	}
})