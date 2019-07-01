({
  init: function (component, event, helper) {
      
    helper.component = component
    let options = component.get("v.options")
    let object = component.get("v.object");
    if(typeof component.get("v.object") === "object"){
         var objectJSON =  JSON.stringify(component.get("v.object"))
         object = JSON.parse(JSON.stringify(component.get("v.object"))).attributes.type
    }
    let field = component.get("v.field")
    //component.set("v.value","");
    console.log( component.get("v.value"));
    let rTDeveloperName = component.get("v.recordTypeDeveloperName")
    var FromSobject = component.get("v.FromSobject");
      if (FromSobject){
          helper.fireApex("c.getPicklistFromSobjectValues", { fld: field, obj: object,recordTypeDeveloperName: rTDeveloperName  }, "v.options");
      }else if (options.length === 0) {
        helper.fireApex("c.getPicklistValues", { fld: field, obj: object,recordTypeDeveloperName: rTDeveloperName }, "v.options");
      }
  },
  //<!-- 07/02/2019 Incapsulate Added function for depedent skip logic-->
  onInputChange : function(component, event, helper){       
       var value = event.getSource().get("v.value");   
      if(value){
          component.set("v.value",value);
      }
       if(component.get("v.dependencyId")){
            var appEvent = $A.get("e.c:onChangeApplicationEvent");
            appEvent.setParams({
                "fieldValueObject":{
                    "dependencyId" : component.get("v.dependencyId"),
                    "dependsOnId" : component.get("v.dependsOnId"),
                    "dependsOnValue" : value,
                    "cardIndex" : component.get("v.fieldBinding") ? component.get("v.indexVal") : null
                }
            });
            appEvent.fire();
        }        
    }
})