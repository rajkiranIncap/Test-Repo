({
  init : function (cmp,event,helper) {      
      var url = helper.getURL();
      var policyId = url.IncomingPolicyID;
      
      var action = cmp.get("c.getPolicyType");
      action.setParams({
            policyId : policyId
      });
      
      action.setCallback(this,function(response){
      	var state = response.getState();
      	if (cmp.isValid() && state == "SUCCESS"){
        	var policyType = response.getReturnValue();
            if(policyType === 'Home'){
                var incomingPolicyparam = [{name: "IncomingPolicyID",type:"String",value:policyId}];
                if(incomingPolicyparam){
                	cmp.set("v.isLaunchFlow",true);
                    var flow = cmp.find("flow");
                    if(flow){flow.startFlow("Claim_Flow_for_Home", incomingPolicyparam);}
                }  
            }else if(policyType === 'Auto'){
                var incomingPolicyparam = [{name: "IncomingPolicyID",type:"String",value:policyId}];
                if(incomingPolicyparam){
                	cmp.set("v.isLaunchFlow",true);
                    var flow = cmp.find("flow");
                    if(flow){flow.startFlow("Auto_Insurance_Quote", incomingPolicyparam);}
                }
            }
        }
      });
      
      $A.enqueueAction(action);  
  }
})