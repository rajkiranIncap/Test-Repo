({
	doInit : function(component, event, helper) {
		var action = component.get("c.getPolicies");
        /*
        action.setParams({
            UserId : component.get("v.Id")
        });
		*/
		action.setCallback(this,function(response){
            var state = response.getState();
            if (component.isValid() && state == "SUCCESS")
            {
                console.log('response --> ' + JSON.stringify(response.getReturnValue()));
                component.set("v.PolicyList",response.getReturnValue());
                
            }
           
            else if (state === "ERROR" || state === "INCOMPLETE") 
            {
                
            } 
           
        });
        $A.enqueueAction(action);
	},
    
    
    handleClick : function(component, event, helper){
        var idx = event.target.id;
        window.open('/s/start-a-claim?IncomingPolicyID='+idx, 'Test');
    }
})