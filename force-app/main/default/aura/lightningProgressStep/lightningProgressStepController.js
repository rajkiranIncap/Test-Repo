({
	selectFromHeaderStep : function(component,event,helper){
        component.getSuper().set("v.currentStep", component.get("v.currentStage"));
       /* 
        * Need to create the comonent event and click on the header , need to forward the screen
        * var availableActions = ["NEXT"];
              for (var i = 0; i < availableActions.length; i++) {
                 if (availableActions[i] == "BACK") {
                    component.getSuper().set("v.canBack", true);
                 } else if (availableActions[i] == "NEXT") {
                    component.getSuper().set("v.canNext", true);
                 } 
              } 
        var action=component.getSuper().get("v.actionClicked");
        var navigate = component.getSuper().get('v.navigateFlow');  
        navigate("NEXT");*/
    }
})