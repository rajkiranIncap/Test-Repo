({
    doInit : function(component, event, helper) {
		var action = component.get("c.getClaims");
  		action.setCallback(this,function(response){
            var state = response.getState();
            if (component.isValid() && state == "SUCCESS")
            {
                console.log('response --> ' + JSON.stringify(response.getReturnValue()));
                component.set("v.ClaimList",response.getReturnValue());              
            }
           
            else if (state === "ERROR" || state === "INCOMPLETE") 
            {
                
            } 
           
        });
        $A.enqueueAction(action);
	}
    
})