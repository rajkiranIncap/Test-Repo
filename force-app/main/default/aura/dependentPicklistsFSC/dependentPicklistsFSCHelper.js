({
    //all credit to: http://sfdcmonkey.com/2016/12/05/how-to-fetch-picklist-value-from-sobject-and-set-in-uiinputselect/
    fetchPickListVal: function(component, objectName, fieldName, targetControl) {
        var action = component.get("c.getSelectOptions");

        action.setParams({
            "objectName": objectName,
            "fld": fieldName
        });

        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                console.log("returning successfully");
                var allValues = response.getReturnValue();
                console.log("response is: " + response); 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: "none"
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                console.log(opts);
                component.set(targetControl, opts);
            }
        });
        $A.enqueueAction(action);
    },//<!-- 07/02/2019 Incapsulate Added function for depedent skip logic-->
  onInputChange : function(component, event){       
       var value = event.getSource().get("v.value");       
       if(component.get("v.dependencyId")){
            var appEvent = $A.get("e.c:onChangeApplicationEvent");
            appEvent.setParams({
                "fieldValueObject":{
                    "dependencyId" : component.get("v.dependencyId"),
                    "dependsOnId" : component.get("v.dependsOnId"),
                    "dependsOnValue" : value
                }
            });
            appEvent.fire();
        }        
    }
})