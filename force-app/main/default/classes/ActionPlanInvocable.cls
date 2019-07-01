global class ActionPlanInvocable {
	@InvocableMethod(label='insert an action plan')
    public static void insertaction(Id [] oppoId){
                       ActionPlan actionPlans = new ActionPlan();
                       actionPlans.Name = 'Plan_Template_Version__r.Name';
                       actionPlans.TargetId = oppoId[0];//string.valueof(opportunity.Id);
                       actionPlans.ActionPlanTemplateVersionId = '0PT4P000000fyKuWAI';//actionPlanTemplate.Action_Plan_Template_Version__r.Id;
                       actionPlans.ActionPlanType = 'Industries';
                       actionPlans.IsUsingHolidayHours = true;
                       actionPlans.StartDate = date.today();
                       actionPlans.OwnerId = UserInfo.getUserId();
                       insert actionPlans;        
    }
}