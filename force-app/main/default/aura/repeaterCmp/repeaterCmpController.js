/*<!-- 
* @Author Incapsulate
* @Since 02-05-2019
* @Description: Used for repeater controller.
-->*/
    
({
	doInit : function(component, event, helper) {
        helper.getParamFromUrlAndSet(component, event);
        component.set('v.validate', function() {            	
            	  return { 
                      isValid: helper.validate(component), 
                      errorMessage: '' 
                  }; 
              });
        
		var action = component.get('c.getComponentsByGroupName');
        action.setParams({
            'groupName': component.get("v.groupName")
		});
        action.setCallback(this, function(response) {
            if(component.isValid()) {
                if(response.getState() === 'SUCCESS') {
                    var toCreate = response.getReturnValue();
                    component.set('v.toCreate', toCreate);

                    var objectType = component.get('v.objectType');
                    var recordTypeId = component.get('v.recordTypeId');
                    var parentId = component.get('v.parentId');
                    var parentField = component.get('v.parentField');;
                    var fields = [];
                    for(var index in toCreate) {
                        if(toCreate[index].attributes && toCreate[index].attributes.fieldBinding) {
                            fields.push(toCreate[index].attributes.fieldBinding);
                        }
                    }
                    /*
                    var itemsAction = component.get('c.getRecords');
                    itemsAction.setParams({
                        'objectType': objectType,
                        'recordTypeId': recordTypeId,
                        'parentId': parentId,
                        'parentField': parentField,
                        'fields': fields
                    });
                    itemsAction.setCallback(this, function(response) {
                        if(component.isValid()) {
                            if(response.getState() === 'SUCCESS') {
                                var records = response.getReturnValue();
                                console.log(records);
                            }
                            else {
                                console.log('Error while getting repeater records');
                            }
                        }
                    });
                    $A.enqueueAction(itemsAction);
                    */
                    var value = component.get('v.value');
                    if(value) {
                            var existingval = component.get("v.value");
                            if(JSON.parse(existingval).saved){
                                var valueobj = JSON.parse(existingval).saved;                                
                                value = JSON.stringify(valueobj);
                                component.set("v.value",value);
                            }
                        helper.addItems(component, JSON.parse(value));
                    }
                }
                else {
                    console.log('Error while getting repeater metadata');
                }
            }
        });
        $A.enqueueAction(action);
	},
    addClicked: function(component, event, helper) {
        helper.addItems(component);
    },
    deleteClicked: function(component, event, helper) {
        var targetId = event.getSource().getGlobalId();
        var components = component.get('v.components');
        var newList = [];
        var deletedRecords = component.get('v.deletedRecords');
        var objectType = component.get('v.objectType');
        if(!deletedRecords) {
            deletedRecords = [];
        }
        for(var index in components) {
            if(components[index].getGlobalId() !== targetId) {
                newList.push(components[index]);
            }
            else if(components[index].getValue) {
                var record = components[index].getValue();
                if(record.Id) {
                    if(objectType) {
                        record.SObjectType = objectType;
                        record.attributes = {
                            "type" : objectType
                        }
                    }
                    deletedRecords.push(record);
                }
            }
        }
        
        component.set('v.components', newList);
        component.set('v.deletedRecords', deletedRecords)
    },
    /*doneRendering: function(component, event, helper) {
        if(component.get('v.shouldRegister')) {
            var register = $A.get('e.INLA:registerValidation');
            register.fire();
        }
    },
    validate: function(component, event, helper) {
        if(component.get('v.shouldRegister')) {
            return helper.fireValidationResult(component);
        }
    }*/
})