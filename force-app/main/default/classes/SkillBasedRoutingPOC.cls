public class SkillBasedRoutingPOC {
    
    public static Map<Id,Lead> leadMap;
    
    public static void createPendingServiceRouting(List<Lead> leads)
    {
        Set<Id> processingLeadIds = New Set<Id>();
        for(Lead LeadObj : leads){
            processingLeadIds.add(leadObj.Id);
        }
        
        leads = [Select Id,Product__c,Product__r.Name,Product__r.Lead_Processing_Priority__c,Product__r.Lead_Processing_Skill__c
                 FROM Lead WHERE Id In: processingLeadIds];
        
        List<PendingServiceRouting> psrListInsert = new List<PendingServiceRouting>();
        List<PendingServiceRouting> psrListDelete = new List<PendingServiceRouting>();
        Map<Id, PendingServiceRouting>  psrListInsertMap = new Map<Id, PendingServiceRouting>();
        Map<Id,Lead> psrToLead = new Map<Id,Lead>();  //psr ID => Lead
        Map<Id,Lead> leadIdMap = new Map<Id,Lead>();  // case ID => Lead
        
        leadMap = new Map<Id, Lead>();
        leadMap.putAll(leads);
        
        Map<Id, PendingServiceRouting> leadIdByPSRMap = new Map<Id,PendingServiceRouting>();
        
        for(PendingServiceRouting psr : [SELECT Id,CapacityWeight,IsReadyForRouting,RoutingModel,RoutingPriority,RoutingType,ServiceChannelId, WorkItemId, PushTimeout 
                                        FROM PendingServiceRouting 
                                        WHERE WorkItemId IN :leadMap.values() AND isReadyForRouting = true]){
            leadIdByPSRMap.put(psr.WorkItemId, psr);
        }

        String strChannelId = getChannelId();
        
        Map<Id, Id> leadToSkillMap = getLeadToSkillId(leadMap);
        system.debug(leadToSkillMap);
        for(Lead LeadObj : leads)
        {
            // Deleting existing psr as once active, it can't be updated
            if(!leadIdByPSRMap.isEmpty() && leadIdByPSRMap.containsKey(LeadObj.Id) <> null ){
                psrListDelete.add(leadIdByPSRMap.get(LeadObj.Id));
            }
            
            if(leadToSkillMap.containsKey(LeadObj.Id)){
            
                // Create a new SkillsBased PendingServiceRouting
                PendingServiceRouting psrObj = new PendingServiceRouting(
                    CapacityWeight = 1,
                    IsReadyForRouting = FALSE,
                    RoutingModel  = 'MostAvailable',
                    RoutingPriority = LeadObj.Product__r.Lead_Processing_Priority__c != null ? Integer.valueOf(LeadObj.Product__r.Lead_Processing_Priority__c) : 1,
                    RoutingType = 'SkillsBased',
                    ServiceChannelId = strChannelId,
                    WorkItemId = LeadObj.Id,
                    PushTimeout = 0
                );
                
                psrListInsert.add(psrObj);
            }
            leadIdMap.put(LeadObj.id, LeadObj);
        }
        
        if(!psrListDelete.isEmpty()){
            delete psrListDelete;
        }
        system.debug(psrListInsert);
        if(!psrListInsert.isEmpty()){
            insert psrListInsert;
            psrListInsertMap.putAll(psrListInsert);
        }

        //build a map of psr ID => Lead
        for(PendingServiceRouting psr : psrListInsertMap.values()){
            psrToLead.put(psr.Id, leadIdMap.get(psr.WorkItemId));
        }
        
        List<SkillRequirement> skillRequirements = new List<SkillRequirement>();
        
        for(PendingServiceRouting psr : psrListInsertMap.values()){
            
            if(!leadToSkillMap.isEmpty() && leadToSkillMap.get(psr.WorkItemId) != null){
                SkillRequirement skillReqObj = new SkillRequirement(
                    RelatedRecordId = psr.id,
                    SkillId = leadToSkillMap.get(psr.WorkItemId)
                );
                
                skillRequirements.add(skillReqObj);
            }
           
            psr.IsReadyForRouting = TRUE;
        }  
        system.debug(psrListInsertMap);
        //add all skill requirements, then update to send to routing
        if(!skillRequirements.isEmpty())   insert skillRequirements;
        if(!psrListInsertMap.isEmpty())    update psrListInsertMap.values();
    }
    
    static String getChannelId(){
        List<ServiceChannel> channelList = new List<ServiceChannel>([Select Id From ServiceChannel Where RelatedEntity = 'Lead']);
        if(!channelList.isEmpty()){
            return channelList[0].Id;
        }
        return null;
    }
    
    static Map<Id,Id> getLeadToSkillId(Map<Id,Lead> processingLeads){
        
        Set<String> requiredSkills = New Set<String>();
        
        for(Lead leadObj : processingLeads.values()){
            if(leadObj.Product__r.Lead_Processing_Skill__c != null){
                requiredSkills.add(leadObj.Product__r.Lead_Processing_Skill__c);
            }
        }
        
        Map<String, Id> skillNameToIDs = new Map<String, Id>();
        
        Skill [] skills = [Select Id,MasterLabel From Skill Where MasterLabel in :requiredSkills];
        
        for (Skill s : skills) {
            skillNameToIDs.put(s.MasterLabel, s.id);
        }
        
        Map<id,id> LeadIdToSkillId = New Map<id,id>();
        for(Id leadId : processingLeads.keySet()){
            if(processingLeads.containsKey(leadId)
            && skillNameToIDs.containsKey(processingLeads.get(leadId).Product__r.Lead_Processing_Skill__c))
            LeadIdToSkillId.put(leadId,skillNameToIDs.get(processingLeads.get(leadId).Product__r.Lead_Processing_Skill__c));
        }
        
        return LeadIdToSkillId;
    }
}