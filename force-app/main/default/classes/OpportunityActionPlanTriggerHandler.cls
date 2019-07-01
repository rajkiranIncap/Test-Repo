public class OpportunityActionPlanTriggerHandler {
	public static void createActionPlan(List<Opportunity_Action_Plan__e> oppActionPlanList){
        
        List<ActionPlan> actionPlanList = new List<ActionPlan>();
        
        for(Opportunity_Action_Plan__e oppActionPlan : oppActionPlanList){
        	ActionPlan actionPlans = new ActionPlan();
            actionPlans.Name = oppActionPlan.Name__c;
            actionPlans.TargetId = oppActionPlan.Opportunity_ID__c;
            actionPlans.ActionPlanTemplateVersionId = oppActionPlan.Action_Template_Version_ID__c;
            actionPlans.ActionPlanType = 'Industries';
            actionPlans.IsUsingHolidayHours = true;
            actionPlans.StartDate = date.today();
            //actionPlans.OwnerId = UserInfo.getUserId();
            actionPlanList.add(actionPlans);    
        }
        
        system.debug('actionPlanList: ' + actionPlanList);
        
        insert actionPlanList;
    }
}