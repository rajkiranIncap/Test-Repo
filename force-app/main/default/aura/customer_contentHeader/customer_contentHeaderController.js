({
	doneRendering: function(component, event, helper) {
        var loggedInUser = component.get('v.loggedInUser');
        alert(loggedInUser);
        if(!loggedInUser) {
            var stateRequested = $A.get('e.c:stateChanged');
            stateRequested.fire();
        }
	},
    stateChanged: function(component, event, helper) {
        var loggedInUser = component.get('v.loggedInUser');
        var appState = event.getParam('appState');
        alert('appState--'+appState);
        if(appState && appState.currentUser.Id)
        {
            component.set('v.loggedInUser', appState.currentUser);
        }
    }
})