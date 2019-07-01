({
   init : function(cmp, event, helper) {
       cmp.set("v.ValidityCount",0);
       cmp.set("v.isValidList",[]);
       
       // Set the validate attribute to a function that includes validation logic. 
        cmp.set('v.validate', function() { 
              if(true) { 
                  cmp.set("v.ValidityCount",0);
       			  cmp.set("v.isValidList",[]);
                  cmp.set("v.componentCount",0);
                  return { isValid: true }; 
              } 
              else { 
                  //If the component is invalid, return the isValid parameter as false and return an error message. 
                  return { 
                      isValid: false, 
                      errorMessage: '/*A message that helps your user enter a valid value or explains what went wrong.*/' 
                  }; 
              }}) 
      // Figure out which buttons to display
      var availableActions = cmp.get('v.availableActions');
      for (var i = 0; i < availableActions.length; i++) {
         if (availableActions[i] == "PAUSE") {
            cmp.set("v.canPause", true);
         } else if (availableActions[i] == "BACK") {
            cmp.set("v.canBack", true);
         } else if (availableActions[i] == "NEXT") {
            cmp.set("v.canNext", true);
         } else if (availableActions[i] == "FINISH") {
            cmp.set("v.canFinish", true);
         }
      }
       
       
   },
        
   onButtonPressed: function(cmp, event, helper) {
       console.log('button pressed')
       //Added for ILA LIte 
       cmp.set("v.actionClicked",event.getSource().getLocalId());
       var appSyncEvent = $A.get("e.c:eventToValidateComponent");
       appSyncEvent.setParams({
           "calledForCount": false,
           "isValid": true,
           "calledForValidation": true
       });
       
       appSyncEvent.fire();
      // Figure out which action was called
      var appSyncEvent = $A.get("e.c:eventToSyncSobject");
        appSyncEvent.setParams({
            "FormDetailObject":{
                "actionClicked" : event.getSource().getLocalId()
                
            }
        });
        appSyncEvent.fire();
       
      //var actionClicked = event.getSource().getLocalId();
      // Fire that action
      
       
   },
    
    //Added for ILA Lite support
    handleApplicationCountComponent : function(component,event,helper){
        if(event.getParam("calledForValidation")){
            var validList = component.get("v.isValidList");
            validList.push(event.getParam("isValid"));
            component.set("v.isValidList",validList);
            component.set("v.ValidityCount",component.get("v.ValidityCount")+1);
            if(component.get("v.ValidityCount")==component.get("v.componentCount")){
                validList=component.get("v.isValidList");
                var flag=0;
                for(var i in validList){
                    if(!validList[i])
                        flag=1;
                }
                if(flag==1){
                    component.set("v.ValidityCount",0);
                    component.set("v.isValidList",[]);
                    console.log("Component is INAVLID")
                }
                else{
                    component.set("v.componentCount",0);
                    var action=component.get("v.actionClicked");
                    var navigate = component.get('v.navigateFlow'); 
                    component.set("v.ValidityCount",0);
                    component.set("v.isValidList",[]);                    
                    navigate(action);
                }
            }
        }
        else{            
            if(event.getParam("count") == 1){
                component.set("v.componentCount",component.get("v.componentCount")+event.getParam("count"));
                console.log("COUNT-->"+component.get("v.componentCount"))
            }
        }
        
    } 
    
})