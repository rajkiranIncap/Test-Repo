public class SkillBasedRoutingPOCCase {
    
    public static Map<Id,Case> CaseMap;
    
    public static void createPendingServiceRouting(List<Case> Cases)
    {
        Set<Id> processingCaseIds = New Set<Id>();
        for(Case CaseObj : Cases){
            processingCaseIds.add(CaseObj.Id);
        }
        
        Cases = [Select Id,Skill__c
                 FROM Case WHERE Id In: processingCaseIds];
        
        List<PendingServiceRouting> psrListInsert = new List<PendingServiceRouting>();
        List<PendingServiceRouting> psrListDelete = new List<PendingServiceRouting>();
        Map<Id, PendingServiceRouting>  psrListInsertMap = new Map<Id, PendingServiceRouting>();
        Map<Id,Case> psrToCase = new Map<Id,Case>();  //psr ID => Case
        Map<Id,Case> CaseIdMap = new Map<Id,Case>();  // case ID => Case
        
        CaseMap = new Map<Id, Case>();
        CaseMap.putAll(Cases);
        
        Map<Id, PendingServiceRouting> CaseIdByPSRMap = new Map<Id,PendingServiceRouting>();
        
        for(PendingServiceRouting psr : [SELECT Id,CapacityWeight,IsReadyForRouting,RoutingModel,RoutingPriority,RoutingType,ServiceChannelId, WorkItemId, PushTimeout 
                                        FROM PendingServiceRouting 
                                        WHERE WorkItemId IN :CaseMap.values() AND isReadyForRouting = true]){
            CaseIdByPSRMap.put(psr.WorkItemId, psr);
        }

        String strChannelId = getChannelId();
        
        Map<Id, Id> CaseToSkillMap = getCaseToSkillId(CaseMap);
        
        for(Case CaseObj : Cases)
        {
            // Deleting existing psr as once active, it can't be updated
            if(!CaseIdByPSRMap.isEmpty() && CaseIdByPSRMap.containsKey(CaseObj.Id) <> null ){
                psrListDelete.add(CaseIdByPSRMap.get(CaseObj.Id));
            }
            
            if(CaseToSkillMap.containsKey(CaseObj.Id)){
            
                // Create a new SkillsBased PendingServiceRouting
                PendingServiceRouting psrObj = new PendingServiceRouting(
                    CapacityWeight = 1,
                    IsReadyForRouting = FALSE,
                    RoutingModel  = 'MostAvailable',
                    RoutingPriority = 1,
                    RoutingType = 'SkillsBased',
                    ServiceChannelId = strChannelId,
                    WorkItemId = CaseObj.Id,
                    PushTimeout = 0
                );
                
                psrListInsert.add(psrObj);
            }
            CaseIdMap.put(CaseObj.id, CaseObj);
        }
        
        if(!psrListDelete.isEmpty()){
            delete psrListDelete;
        }
        system.debug(psrListInsert);
        if(!psrListInsert.isEmpty()){
            insert psrListInsert;
            psrListInsertMap.putAll(psrListInsert);
        }

        //build a map of psr ID => Case
        for(PendingServiceRouting psr : psrListInsertMap.values()){
            psrToCase.put(psr.Id, CaseIdMap.get(psr.WorkItemId));
        }
        
        List<SkillRequirement> skillRequirements = new List<SkillRequirement>();
        
        for(PendingServiceRouting psr : psrListInsertMap.values()){
            
            if(!CaseToSkillMap.isEmpty() && CaseToSkillMap.get(psr.WorkItemId) != null){
                SkillRequirement skillReqObj = new SkillRequirement(
                    RelatedRecordId = psr.id,
                    SkillId = CaseToSkillMap.get(psr.WorkItemId)
                );
                
                skillRequirements.add(skillReqObj);
            }
           
            psr.IsReadyForRouting = TRUE;
        }  
        system.debug(psrListInsertMap);
        system.debug(skillRequirements);
        //add all skill requirements, then update to send to routing
        if(!skillRequirements.isEmpty())   insert skillRequirements;
        if(!psrListInsertMap.isEmpty())    update psrListInsertMap.values();
    }
    
    static String getChannelId(){
        List<ServiceChannel> channelList = new List<ServiceChannel>([Select Id From ServiceChannel Where RelatedEntity = 'Case']);
        if(!channelList.isEmpty()){
            return channelList[0].Id;
        }
        return null;
    }
    
    static Map<Id,Id> getCaseToSkillId(Map<Id,Case> processingCases){
        
        Set<String> requiredSkills = New Set<String>();
        
        for(Case CaseObj : processingCases.values()){
            if(CaseObj.Skill__c != null){
                requiredSkills.add(CaseObj.Skill__c);
            }
        }
        
        Map<String, Id> skillNameToIDs = new Map<String, Id>();
        
        Skill [] skills = [Select Id,MasterLabel From Skill Where MasterLabel in :requiredSkills];
        
        for (Skill s : skills) {
            skillNameToIDs.put(s.MasterLabel, s.id);
        }
        
        Map<id,id> CaseIdToSkillId = New Map<id,id>();
        for(Id CaseId : processingCases.keySet()){
            if(processingCases.containsKey(CaseId)
            && skillNameToIDs.containsKey(processingCases.get(CaseId).Skill__c))
            CaseIdToSkillId.put(CaseId,skillNameToIDs.get(processingCases.get(CaseId).Skill__c));
        }
        
        return CaseIdToSkillId;
    }
}