public class AgentWorkTriggerHandler {
    
    public static void handleLeadAgentWork(List<AgentWork> TriggerNewList){
        List<ActionPlan> listOfActionPlan = New List<ActionPlan>();
        Set<Id> setOfLeadId = New Set<Id>();
        
        ActionPlanTemplateVersion ActionPlanTemplateVersionSO = [Select Id,Name From ActionPlanTemplateVersion
                                                                 Where Name = 'Lead Action Plan' LIMIT 1];
        
        for(AgentWork agentworkItem : TriggerNewList){
            String ObjName = agentworkItem.workItemId.getSObjectType().getDescribe().getName();
            if(ObjName == 'Lead'){
                ActionPlan actionPlan = new ActionPlan();
                actionPlan.TargetId = agentworkItem.workItemId;
                actionPlan.ActionPlanTemplateVersionId = ActionPlanTemplateVersionSO.Id;
                actionPlan.ActionPlanType = 'Industries';
                actionPlan.IsUsingHolidayHours = false;
                actionPlan.StartDate = date.today();
                actionPlan.Name = ActionPlanTemplateVersionSO.Name;
                actionPlan.ActionPlanState ='Not Started';
                listOfActionPlan.add(actionPlan);
            	setOfLeadId.add(agentworkItem.workItemId);
            }
        }
        
        List<Lead> listOfLeadsToUpdate = [Select Id,Status From Lead Where Id IN: setOfLeadId];
        for(Lead leadSO : listOfLeadsToUpdate){
            leadSO.Status = 'Open - Working';
        }
        try{
            insert listOfActionPlan;
            update listOfLeadsToUpdate;
        }Catch(Exception e){
            system.debug(e.getStackTraceString());
            system.debug(e.getMessage());
        }
    }
}