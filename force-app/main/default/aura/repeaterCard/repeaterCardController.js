({
    doInit: function(component, event, helper) {
        var value = component.get('v.value');
        var toCreate = component.get("v.toCreate");
        if(toCreate && toCreate.length) {
            var listToCreate = [], cmpName, attributes;
            for(var index in toCreate) {
                cmpName = toCreate[index].sections[0].component.Name;
                attributes = toCreate[index].sections[0].attributes;
               // if(value && attributes.fieldBinding && value[attributes.fieldBinding]) {
                if(attributes.fieldBinding) {
                    debugger;
                    //attributes.value = value[attributes.fieldBinding];
                    //if(component.getSuper('v.objectVal')){
                    /*var contactattributes = {type: attributes.objectType, url:"/services/data/v45.0/sobjects/"+attributes.objectType };
                    var recordObj = {};        
                    recordObj["attributes"] = contactattributes;
                    component.set('v.objectVal',recordObj);*/
                    console.log('>>>'+attributes.fieldBinding);
                    attributes.value = component.getReference('v.value.'+attributes.fieldBinding);
                    
                    	
                    //}
                }
                attributes.shouldRegister = false;
                attributes.genericObjectValue = component.getReference('v.value');
                attributes.indexVal = component.get('v.cardIndex');
                attributes.parentFieldName = component.get('v.parentFieldName');
                listToCreate.push([cmpName, attributes]);
            }
            /*[["c:lightningInput",{
                "value" :"Message1",
                "type":"date",
                "label":"f name"
            }]]*/
            debugger;
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
        console.log('<---Delete Clicked inside repeaterCard cmp--->'+component.get('v.cardIndex'));
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