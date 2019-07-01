trigger CustomOpportunityTrigger on Opportunity (after update, before update, before insert) {
    Set<Id> opportunityApprovedList = new Set<Id>();
    List<Opportunity> opportunityRejectedList = new List<Opportunity>();
    List<Opportunity> opportunityList = new List<Opportunity>();
    
    if((trigger.isUpdate || trigger.isInsert) && trigger.isBefore){        
        for(Opportunity opportunity : trigger.new){  
            if(trigger.OldMap == null || opportunity.StageName != trigger.OldMap.get(opportunity.Id).StageName){
            	opportunityList.add(opportunity);
            }
        }
        if(opportunityList.size() > 0){
            CustomOpportunityTriggerHandler.createActionPlan(opportunityList);
        }
        
        //Lead Conversion Logic - Added by Tejas
        List<Opportunity> optyToProcess= new List<Opportunity>();
        List<Opportunity> opportunityCaseList = new List<Opportunity>();
        for(Opportunity opp : trigger.new){            
            if(opp.StageName.containsIgnoreCase('Close') && opp.Send_For_QC_Review__c && opp.StageName != trigger.OldMap.get(opp.Id).StageName){
                opportunityCaseList.add(opp);
            }
            if(String.isNotBlank(opp.Converted_LeadID__c) && String.IsBlank(trigger.OldMap.get(opp.Id).Converted_LeadID__c)){
                optyToProcess.add(opp);
            }
        }
        if(opportunityCaseList.size() > 0){
            CustomOpportunityTriggerHandler.createCase(opportunityCaseList);
        }
        if(optyToProcess.size() > 0){
        	LeadConversionEngine.processConvertedLeads(optyToProcess);
        }
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        for(Opportunity opportunity : trigger.new){
            /*if(opportunity.StageName != trigger.oldMap.get(opportunity.Id).StageName){
                opportunityList.add(opportunity);
            }*/
            if(opportunity.Approved_Date__c != null && trigger.oldMap.get(opportunity.Id).Approved_Date__c == null){
                opportunityApprovedList.add(opportunity.Id);
            }
            /*if(opportunity.StageName == 'Rejected' && opportunity.StageName <> trigger.oldMap.get(opportunity.Id).StageName){
                opportunityRejectedList.add(opportunity);
            }*/
        }
        if(opportunityApprovedList.size() > 0){
            CustomOpportunityTriggerHandler.closeTask(opportunityApprovedList);
        }
        if(opportunityRejectedList.size() > 0){
            CustomOpportunityTriggerHandler.sendRejectionTask(opportunityRejectedList);
        }
    }
}