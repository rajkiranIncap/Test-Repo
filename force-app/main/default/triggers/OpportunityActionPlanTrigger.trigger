trigger OpportunityActionPlanTrigger on Opportunity_Action_Plan__e (after insert) {
	if(trigger.isAfter && trigger.isInsert){
        OpportunityActionPlanTriggerHandler.createActionPlan(trigger.new);
    }
}