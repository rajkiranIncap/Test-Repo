public class ActionPlanTriggerHandler {
    public static void updateOpportunityStage(List<ActionPlan> actionPlanList){
        Set<Id> actionPlanTemplateSet = new Set<Id>();
        Set<Id> opportunitySet = new Set<Id>();
        
        for(ActionPlan actionPlan : actionPlanList){
            actionPlanTemplateSet.add(actionPlan.ActionPlanTemplateVersionId);
            opportunitySet.add(actionPlan.TargetId);
        }
        
        Map<Id, ActionPlan> actionPlanMap = new Map<Id, ActionPlan>([select Id, Name, ActionPlanState, ActionPlanTemplateVersion.Name,
                                                                     TargetId from ActionPlan where Id in : actionPlanList]);
        
        system.debug('actionPlanMap: ' + actionPlanMap);
        
        Map<Id, ActionPlanTemplate> actionPlanTemplateMap = new Map<Id, ActionPlanTemplate>([select Id, Name from ActionPlanTemplate where id in : actionPlanTemplateSet]);
        
        system.debug('actionPlanTemplateMap: ' + actionPlanTemplateMap);
        
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([select Id, StageName from Opportunity where id in : opportunitySet]);
        
        system.debug('opportunityMap: ' + opportunityMap);
        
        List<Action_Plan_Completion_Opportunity_Stage__mdt> actionPlanCompletionStageList = [select Id, New_Stage__c, Action_Plan_Template_Name__c, Previous_Stage__c
                                                                                             from Action_Plan_Completion_Opportunity_Stage__mdt limit 100];
        
        Map<string, List<Action_Plan_Completion_Opportunity_Stage__mdt>> templateActionPlanCompletionMap = new Map<string, List<Action_Plan_Completion_Opportunity_Stage__mdt>>();
        
        for(Action_Plan_Completion_Opportunity_Stage__mdt actionPlanCompletionStage : actionPlanCompletionStageList){
            List<Action_Plan_Completion_Opportunity_Stage__mdt> actionPlanCompletionStages;
            if(templateActionPlanCompletionMap.get(actionPlanCompletionStage.Action_Plan_Template_Name__c) == null){
                actionPlanCompletionStages = new List<Action_Plan_Completion_Opportunity_Stage__mdt>();
            }
            else{
                actionPlanCompletionStages = templateActionPlanCompletionMap.get(actionPlanCompletionStage.Action_Plan_Template_Name__c);
            }
            actionPlanCompletionStages.add(actionPlanCompletionStage);
            templateActionPlanCompletionMap.put(actionPlanCompletionStage.Action_Plan_Template_Name__c, actionPlanCompletionStages);
        }
        
        system.debug('templateActionPlanCompletionMap: ' + templateActionPlanCompletionMap);
        
        List<Opportunity> opportunityList = new List<Opportunity>();
        
        for(Id actionPlanId : actionPlanMap.keySet()){
            if(templateActionPlanCompletionMap.containsKey(actionPlanMap.get(actionPlanId).ActionPlanTemplateVersion.Name)){
                system.debug('1');
                List<Action_Plan_Completion_Opportunity_Stage__mdt> actionPlanCompletionStages = templateActionPlanCompletionMap.get(actionPlanMap.get(actionPlanId).ActionPlanTemplateVersion.Name);
                
                system.debug('actionPlanCompletionStages: ' + actionPlanCompletionStages);
                
                Opportunity opportunity = opportunityMap.get(actionPlanMap.get(actionPlanId).targetId);
                
                system.debug('opportunity: ' + opportunity);
                
                if(opportunity.Id != null){
                    for(Action_Plan_Completion_Opportunity_Stage__mdt actionPlanCompletion : actionPlanCompletionStages){
                        system.debug('actionPlanCompletion: ' + actionPlanCompletion);
                        system.debug('opportunity.StageName: ' + opportunity.StageName);
                        if(opportunity.StageName == actionPlanCompletion.Previous_Stage__c){
                            opportunity.StageName = actionPlanCompletion.New_Stage__c;
                            opportunityList.add(opportunity);
                            break;
                        }
                    }
                }
            }
        }
        
        system.debug('opportunityList: ' + opportunityList);
        
        if(opportunityList.size() > 0){
            update opportunityList;
        }
    }
}