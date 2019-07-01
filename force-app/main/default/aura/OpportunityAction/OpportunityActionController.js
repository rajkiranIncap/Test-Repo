({
	doInit : function(component, event, helper) {
		//Init
	},
    
    runRelatedFlow: function(component, event, helper) {
        component.set("v.selectedProcess","needbuildinginfo");
    	helper.runRelatedFlow(component, event, helper);
    },

	handleOpportunityCloseStatusChange : function (component, event, helper) {
     	helper.handleOpportunityCloseStatusChange(component, event);   
    },
    reloadOnModalClose : function (component, event) {
		$A.get('e.force:refreshView').fire();    
	},
    
    hideModal : function(component) {
        var modal = component.find("Modalbox");
        $A.util.removeClass(modal, 'slds-fade-in-open'); 
        $A.util.addClass(modal, 'hideDiv');
        component.set("v.selectedProcess","test");
        //$A.get('e.force:refreshView').fire();    
		//window.location.reload(true);        
    },
})