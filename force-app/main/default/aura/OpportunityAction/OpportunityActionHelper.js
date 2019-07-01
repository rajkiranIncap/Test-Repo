({
	runRelatedFlow: function(component, event, helper) {
		var sourceButton = event.getSource().getLocalId();
        component.set("v.selectedProcess", sourceButton);
        if(sourceButton == 'needbuildinginfo'){
            var inputVariables = [
                { name : "recordId", type : "String", value: component.get("v.recordId")}
            ];
            var cmpTarget = component.find('Modalbox');
            $A.util.addClass(cmpTarget, 'slds-fade-in-open');
            $A.util.removeClass(cmpTarget, 'hideDiv');
            //if(sourceButton == 'needbuildinginfo' ){
            	var flowCmp = component.find("needbuildinginfoFlow");
            	flowCmp.startFlow("List_Of_Buildings", inputVariables);	   
            //}
        }   
	},
    handleOpportunityCloseStatusChange : function (component, event)
    {
        /*var eventId = event.getSource().getLocalId();
        if(event.getParam("status") === "FINISHED")
        {
            if(eventId != 'quickCreateFlow') this.closeCurrentTab(component);
            else
            {
                var outputVariables = event.getParam("outputVariables");
                var outputVar;
                for(var i = 0; i < outputVariables.length; i++)
                {
                    outputVar = outputVariables[i];
                    if(outputVar.name === "varOpportunityId" || outputVar.name === "OpportunityId") {
                        
                        var urlEvent = $A.get("e.force:navigateToSObject");
                        urlEvent.setParams
                        ({
                            "recordId": outputVar.value,
                            "isredirect": "true"
                        });
                        urlEvent.fire();
                        if(event.getSource().toString().includes('rerouteFlow'))
                        {
                            setTimeout(function(){
                                $A.get('e.force:refreshView').fire();    
                            }, 3000);
                        }
                        return;
                    }
                }
            }
       }*/
	},
    
    closeCurrentTab: function(component)
    {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation()
        .then(function(response)
        {
            if(response == true)
            {
                return workspaceAPI.getFocusedTabInfo();
            }
            else
            {
                throw 'AbortError';
            }
        })
        .then(function(response)
        {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
		})
		.catch(function(error)
		{
            console.log('--> Etiher Not a Console navigation or Error!');
            console.log('---> Error - ' + error);
        });
    },
})