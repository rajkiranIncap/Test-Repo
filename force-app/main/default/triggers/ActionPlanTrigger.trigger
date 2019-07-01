trigger ActionPlanTrigger on ActionPlan (after update) {
    if(trigger.isUpdate && trigger.isAfter){
        List<ActionPlan> actionPlanList = new List<ActionPlan>();
        
        for(ActionPlan actionPlan : trigger.new){
            if(actionPlan.ActionPlanState == 'Completed' && actionPlan.ActionPlanState <> trigger.oldMap.get(actionPlan.Id).ActionPlanState){
                actionPlanList.add(actionPlan);
            }
        }

        
        ActionPlanTriggerHandler.updateOpportunityStage(actionPlanList);
    }
}