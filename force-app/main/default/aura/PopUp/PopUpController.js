({
	confirmYes : function(component, event, helper) {
		component.set("v.isOpen",false);
        var cmpEvent = component.getEvent("popUpEvent"); 
        //Set event attribute value
        cmpEvent.setParams({"confirmation" : "Yes"}); 
        cmpEvent.fire(); 
    },
    
    confirmNo : function(component, event, helper) {
		component.set("v.isOpen",false);
        var cmpEvent = component.getEvent("popUpEvent"); 
        //Set event attribute value
        cmpEvent.setParams({"confirmation" : "No"}); 
        cmpEvent.fire(); 
	}
    
})