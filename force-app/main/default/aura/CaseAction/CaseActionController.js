({
	doInit : function(component, event, helper) {
		//Init
	},
    
    runRelatedFlow: function(component, event, helper) {
    	helper.runRelatedFlow(component, event, helper);
    },

	handleCaseCloseStatusChange : function (component, event, helper) {
     	helper.handleCaseCloseStatusChange(component, event);   
    },
    reloadOnModalClose : function (component, event) {
		$A.get('e.force:refreshView').fire();    
	},
    
    hideModal : function(component) {
        var modal = component.find("Modalbox");
        $A.util.removeClass(modal, 'slds-fade-in-open'); 
        $A.util.addClass(modal, 'hideDiv');          
    },
})