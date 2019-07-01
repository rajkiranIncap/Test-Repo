({
    /**
     * Since:  01/05/2019
     * Author: Incapsulate
     * Description: init method to retrived the table header,and row details from the
     * custom metadata and dynamically create the row component as required.
    */
	doInit : function(component, event, helper) {
        if(component.get("v.value")){
            if(JSON.parse(component.get("v.value")).saved){
                component.set("v.objectValList",JSON.parse(component.get("v.value")).saved);            	
            }else{
                component.set("v.objectValList",JSON.parse(component.get("v.value")));
            }
        }
		//helper.getExistingData(component,event);
		//getComponentsByGroupNameNew
		 component.set('v.validate', function() {    
             	console.log(JSON.stringify(component.get("v.objectValList")));
                 var value = {
                    'saved': component.get("v.objectValList"),
                    'deleted': []
                }
                component.set("v.value", JSON.stringify(value));
            	return { 
                      isValid: true, 
                      errorMessage: '' 
                  }; 
              });
        var action = component.get('c.getComponentsByGroupNameNew');
        action.setParams({
            'groupName': component.get('v.groupName')
        });
        action.setCallback(this, function(response) {
            if(component.isValid()) {
                if(response.getState() === 'SUCCESS') {
                    var toCreate = response.getReturnValue();
                    var headerlist = [];
                    if(toCreate[0] && toCreate[0].sections[0] && toCreate[0].sections[0].component){
                        if(toCreate[0].sections[0].component.listOfColumn){
                            component.set("v.formTableHeader",toCreate[0].sections[0].component.listOfColumn);
                        }
                    }
                    component.set('v.toCreate', toCreate);
                    var objectType = component.get('v.objectType');
                    var recordTypeId = component.get('v.recordTypeId');
                    var parentId = component.get('v.parentId');
                    var parentField = component.get('v.parentField');;
                    helper.prepareItems(component, null);
                   
                }
                else {
                    console.log('Error while getting repeater metadata');
                }
            }
        });
        $A.enqueueAction(action);
	},
     /**
     * Since:  01/05/2019
     * Author: Incapsulate
     * Description: whenever the input component is value changes we need to identify the values and
     * calculate the values, This can be on/off based on custom metadata
     * Note: Need to modify code and make the code on/off based on custom metadata.
    */
    handleCloumnValueCalculationSync : function(component, event, helper,nameinput,valueinput){
        helper.handleColumnValueSync(component, event, null,null);
    },
    
})