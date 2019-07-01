({
    doInit: function(component, event, helper) {
        var value = component.get('v.value');
        var toCreate = component.get("v.toCreate");
        if(toCreate && toCreate.length) {
            var listToCreate = [], cmpName, attributes;
            for(var index in toCreate) {
                cmpName = toCreate[index].component.Component_Name__c;
                attributes = toCreate[index].attributes;
                if(value && attributes.fieldBinding && value[attributes.fieldBinding]) {
                    attributes.value = value[attributes.fieldBinding];
                }
                attributes.shouldRegister = false;
                listToCreate.push([cmpName, attributes]);
            }
            $A.createComponents(
                listToCreate,
                function(cmps, status, error){
                    if (status === "SUCCESS") {
                        component.set('v.components', cmps);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                    }
                        else if (status === "ERROR") {
                            console.log(error);
                        }
                }
            );
        }
    },
    doneRendering: function(component, event, helper) {
        
    },
    deleteClicked : function(component, event, helper) {
        var evt = component.getEvent('deleteClicked');
        evt.fire();
	},
    validate: function(component, event, helper) {
        var isValid = helper.validate(component);
        console.log('repeater card valid? ' + isValid);
        return isValid;
    },
    getValue: function(component, event, helper) {
        var components = component.get('v.components');
        var initValue = component.get('v.value');
        var value = {}, fieldBinding, hasBindings = false;
        for(var index in components) {
            fieldBinding = components[index].get('v.fieldBinding')
            console.log(fieldBinding);
            if(fieldBinding) {
                hasBindings = true;
                var fieldValue = components[index].get('v.value');
                if($A.util.isUndefinedOrNull(fieldValue)) {
                    fieldValue = '';
                }
            	value[fieldBinding] = fieldValue;
            }
        }
        if(initValue && initValue.Id) { value.Id = initValue.Id; }
        value = hasBindings? value : null;
        component.set('v.value', value);
        return value;
    }
})