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
        if(toCreate) {
            attributes.toCreate = toCreate;
        }
        if(cardColumns) { attributes.columns = cardColumns; }
        if(cardTitle) { attributes.title = cardTitle; }
        if(cardDescription) { attributes.description = cardDescription; }
        if(cardIcon) { attributes.cardIcon = cardIcon; }
        if(deleteIcon) { attributes.deleteIcon = deleteIcon; }
        debugger;
        console.log("this is teest"+ component.get('v.objectVal'));
        
        //var contactattributes = {type: component.get('v.objectType'), url:"/services/data/v45.0/sobjects/"+component.get('v.objectType') };
		//var recordObj = component.get('v.objectVal');        
        //recordObj["attributes"] = contactattributes;
        //component.set('v.objectVal',recordObj);
        if(component.get('v.objectVal')){
            var jsonobj = JSON.parse(JSON.stringify(component.get('v.objectVal')));
            jsonobj.Id = null;
            component.set("v.objectVal",jsonobj);
        }
        //NOTE: below  condition works for ILA Lite but does not update the related records.
    	//for ILA form rendering, need to analysis. comment out this condition to check for ILA
         else if(!component.get('v.objectVal')){
            var valueClone = {};   
            if(component.get("v.objectType")){
                var objectva = {"attributes":{type: component.get("v.objectType"), url:"/services/data/v45.0/sobjects/"+component.get("v.objectType") }};
                
                component.set("v.objectVal", objectva);
            }
       }
        attributes.value =  component.get('v.objectVal');
        attributes.parentFieldName = component.get('v.parentFieldName');
        //var val1 = '[{"relatedsObject_Contact":{"1":{"attributes":{"type":"Contact","url":"/services/data/v45.0/sobjects/Contact"},"LastName":"lastName","FirstName":"firstName","Email":"email@email.com","AccountId":"parentFieldId"}}}]'
        //values = JSON.parse(val1);
        
		if(values) {
            if(values.length) {
                for(var index in values) {
                    if(Object.values(values[index]["relatedsObject_"+component.get('v.objectType')]).length) {
                        var relatedObjList = Object.values(values[index]["relatedsObject_"+component.get('v.objectType')]);
                        for(var indexVal in relatedObjList) {     
                            console.log("indexVal:::"+indexVal);
                        //if(values[index].relatedsObject_Contact[component.get("v.cardIndex")]){
                            
                            
                            component.set('v.objectVal',values[index]["relatedsObject_"+component.get('v.objectType')][indexVal]);
                            attributes.value = values[index]["relatedsObject_"+component.get('v.objectType')][indexVal];
                            console.log("attributes.value:::"+attributes.value);
                            attributes.cardIndex = indexVal;
                            attributes.indexVal = indexVal;
                            var cloned = Object.assign({}, attributes);
                            cloned.value = values[index]["relatedsObject_"+component.get('v.objectType')][indexVal];
                            listToCreate.push([
                                "c:repeaterCard",
                                cloned
                            ]);
                        //}
                    
                        }
                    }
                }
            }
        }
        else if(!values) {
            var index = component.get("v.cardIndex");
            if(component.get('v.objectValList') && component.get('v.objectValList')[0]
               && component.get('v.objectValList')[0]["relatedsObject_"+component.get('v.objectType')] && 
               Object.values(component.get('v.objectValList')[0]["relatedsObject_"+component.get('v.objectType')]).length){
                var len =Object.values(component.get('v.objectValList')[0]["relatedsObject_"+component.get('v.objectType')]).length;
                if(index < len && index != len){
                	component.set("v.cardIndex",len);
                    component.set("v.indexVal",len);
                }else if(index == len){
                    component.set("v.cardIndex",++len);
                    component.set("v.indexVal",++len);
                }
            	//index = Object.values(component.get('v.objectValList')[0]["relatedsObject_"+component.get('v.objectType')]).length;
                attributes.cardIndex = component.get("v.cardIndex");
                attributes.indexVal = component.get("v.cardIndex");
                //component.set("v.cardIndex",index+1);
            }else{
                attributes.cardIndex = index;
                attributes.indexVal = index;
                //component.set("v.cardIndex",index+1);
            }   
            attributes.Id = null;
            var cloned = Object.assign({}, attributes);            
            
            listToCreate.push([
                "c:repeaterCard",
                cloned
            ]);
            console.log("cardIndex>>"+component.get("v.cardIndex"));
            component.set("v.cardIndex",component.get("v.cardIndex")+1);
            component.set("v.indexVal",component.get("v.cardIndex"));
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
    fireValidationResult: function(component) {
        var isValid = this.validate(component);
    	var validation = $A.get('e.INLA:validationResult');
        validation.setParams({
            'isValid': isValid
        });
        validation.fire();
        return isValid;
	}
})