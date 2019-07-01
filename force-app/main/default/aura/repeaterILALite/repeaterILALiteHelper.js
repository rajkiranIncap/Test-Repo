({
	addItems : function(component, values) {
        var listToCreate = [];
        var toCreate = component.get('v.toCreate');
        var cardColumns = component.get('v.cardColumns');
        var cardTitle = component.get('v.cardTitle');
        var cardDescription = component.get('v.cardDescription');
        var cardIcon = component.get('v.cardIcon');
        var deleteIcon = component.get('v.deleteIcon');
        var attributes = {};
        
        var cardind = component.get("v.cardIndex");
        cardind = cardind +1;
        component.set("v.cardIndex",cardind);
        
        for(var index in toCreate) {
            if(toCreate[index].attributes && toCreate[index].attributes.fieldBinding) {
				          toCreate[index].attributes.indexVal = cardind;      
            }
        }   
        if(toCreate) {
            attributes.toCreate = toCreate;
        }
        if(cardColumns) { attributes.columns = cardColumns; }
        if(cardTitle) { attributes.title = cardTitle; }
        if(cardDescription) { attributes.description = cardDescription; }
        if(cardIcon) { attributes.cardIcon = cardIcon; }
        if(deleteIcon) { attributes.deleteIcon = deleteIcon; }

        if(values) {
            
            if(values.length) {
                for(var index in values) {
                    var cloned = Object.assign({}, attributes);
                    cloned.value = values[index];
                    
                    listToCreate.push([
                        "c:repeaterCardILALite",
                        cloned
                    ]);
                }
            }
        }
        else if(!values) {
            var cloned = Object.assign({}, attributes);
            listToCreate.push([
                "c:repeaterCardILALite",
                cloned
            ]);
        }
		$A.createComponents(
            listToCreate,
            function(cmps, status, error){
                if (status === "SUCCESS") {
                    var components = component.get('v.components');
                    if(!components) { components = []; }
                    for(var index in cmps) {
                        cmps[index].addEventHandler("deleteClicked", component.getReference("c.deleteClicked"));
                        components.push(cmps[index]);                        
                    }
                    component.set('v.components', components);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log(error);
                    }
            }
        );
    },
    deleteItem: function(component, recordId) {
        //do server delete
    },
    validate: function(component) {
        var components = component.get('v.components');
        var isValid = true, cmpValid;
        for(var index in components) {
            if(components[index].validate) {
                cmpValid = components[index].validate();
                console.log(cmpValid);
                isValid = cmpValid && isValid;
            }
        }
        console.log('repeater valid? ' + isValid);
        if(isValid) {
            this.getValue(component);
        }
        return isValid;
    },
    getValue: function(component) {
        var components = component.get('v.components');
        var recordTypeId = component.get('v.recordTypeId');
        var parentId = component.get('v.parentId');
        var parentField = component.get('v.parentField');
        var objectType = component.get('v.objectType');
        var values = [];
        for(var index in components) {
            if(components[index].getValue) {
                var cmpValue = components[index].getValue();
                if(recordTypeId) { cmpValue.RecordTypeId = recordTypeId; }
                if(objectType) {
                    cmpValue.SObjectType = objectType;
                    cmpValue.attributes = {
                        "type" : objectType
                    }
                }
                if(parentId && parentField) { cmpValue[parentField] = parentId; }
                if(cmpValue !== null) {
                	values.push(cmpValue);
                }
            }
        }
        var value = {
            'saved': values,
            'deleted': component.get('v.deletedRecords')
        }

        component.set('v.value', JSON.stringify(value));
    },
    /*fireValidationResult: function(component) {
        var isValid = this.validate(component);
    	var validation = $A.get('e.INLA:validationResult');
        validation.setParams({
            'isValid': isValid
        });
        validation.fire();
        return isValid;
	}*/
    getParamFromUrlAndSet : function(component, event) {
		var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        if(sPageURL){
            var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
            if(sURLVariables){
                var sParameterName;
                var i;
                for (i = 0; i < sURLVariables.length; i++) {
                    sParameterName = sURLVariables[i].split('='); //to split the key from the value.
        
                    if (sParameterName[0] === 'recordId') { //lets say you are looking for param name - firstName
                        sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
                        if(sParameterName[1]){
                            component.set("v.parentId",sParameterName[1]);
                        }
                    }
                }
            }
        }
	}
})