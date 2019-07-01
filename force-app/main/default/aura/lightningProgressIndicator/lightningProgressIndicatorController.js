({
    /**
     * Modified Since:  03/06/2019
     * Author: Incapsulate
     * 
    */
   init : function(component, event, helper) {
      var progressIndicator = component.find('progressIndicator');
       var stagesarra = component.get('v.stagesStr').split(",");
       var activeTab = component.get('v.currentStage');
      component.set('v.stages',stagesarra);
      for (let step of component.get('v.stages')) {
          var attributes = {};
          var listToCreate = [];
          attributes["aura:id"] = "step_" + step;
          attributes.currentStage = step;   
          if(step != activeTab){
              attributes.disabled = "disabled";
          }
          
          var cloned = Object.assign({}, attributes);
            listToCreate.push([
                "c:lightningProgressStep",
                cloned
            ]);
         $A.createComponents(
           /* "lightning:progressStep",
            {
               "aura:id": "step_" + step,
               "label": step,
               "value": step
             }*/
             listToCreate,
             function(newProgressStep, status, errorMessage){
                // Add the new step to the progress array
                if (status === "SUCCESS") {
                   var body = progressIndicator.get("v.body");
                   body.push(newProgressStep);
                   progressIndicator.set("v.body", body);
                    
                    var components = component.get('v.components');
                    if(!components) { components = []; }
                    for(var index in newProgressStep) {
                        components.push(newProgressStep[index]);
                    }
                    component.set('v.components', components);
                 }
                 else if (status === "INCOMPLETE") {
                    // Show offline error
                    console.log("No response from server, or client is offline.")
                  }
                  else if (status === "ERROR") {
                     // Show error message
                     console.log("Error: " + errorMessage);
                  }
              }
           );
       }
   }
})