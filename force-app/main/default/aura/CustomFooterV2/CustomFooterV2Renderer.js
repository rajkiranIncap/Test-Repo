({
	// Your renderer method overrides go here
	afterRender: function (component, helper) {
    //this.superAfterRender();
    // interact with the DOM here
    //Added for ILA LITE
     var appSyncEvent = $A.get("e.c:eventToValidateComponent");
        appSyncEvent.setParams({
            "calledForCount": true,
            "calledForValidation": false
        });
        appSyncEvent.fire();
	},
})