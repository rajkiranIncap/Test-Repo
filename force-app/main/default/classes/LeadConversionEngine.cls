public class LeadConversionEngine {
    
    public static void processConvertedLeads(List<Opportunity> opportunties){
        System.debug('In Side Logic.....');
        Map<Id,Id> convertedOppIds = new Map<Id,Id>();
        
        for(Opportunity opty : opportunties){
            convertedOppIds.put(opty.Converted_LeadID__c,opty.Id);
        }
        
        system.debug('convertedOppIds: ' + convertedOppIds);
        Map<Id,Lead> leads = new Map<Id,Lead>([Select Id,CreatedByID,ConvertedContactId from Lead Where Id In : convertedOppIds.keySet()]);
        
        set<Id> ownerIds = new Set<Id>();
        
        for(Lead l : leads.values()){
            ownerIds.add(l.CreatedByID);
        }
        
        system.debug('ownerIds: ' + ownerIds);
        
        Map<Id,User> users = new Map<Id,User>([Select Id,ContactId,Contact.AccountId from User where Id In: ownerIds ]);
        
        system.debug('users: ' + users);
        
        for(Opportunity opp : opportunties){
            system.debug('opp.Converted_LeadID__c: ' + opp.Converted_LeadID__c);
            system.debug('leads.get(opp.Converted_LeadID__c): ' + leads.get(opp.Converted_LeadID__c));
            system.debug('users.get(leads.get(opp.Converted_LeadID__c).OwnerId).ContactId: ' + users.get(leads.get(opp.Converted_LeadID__c).CreatedByID).ContactId);
            
            if(users.get(leads.get(opp.Converted_LeadID__c).CreatedByID).ContactId!=null){
                opp.Broker_Account__c = users.get(leads.get(opp.Converted_LeadID__c).CreatedByID).Contact.AccountId;
                opp.Broker_Agent__c  = users.get(leads.get(opp.Converted_LeadID__c).CreatedByID).ContactId;
            }            
            opp.Applicant_Contact__c = leads.get(opp.Converted_LeadID__c).ConvertedContactId;
        }
        
        List<OpportunityAsset__c> optyAssets = [Select Id,Lead__c from OpportunityAsset__c Where Lead__c In :  convertedOppIds.keySet()];
        List<Opportunity_Coverage__c> optyCoverage = [Select Id,Lead__c from Opportunity_Coverage__c Where Lead__c In :  convertedOppIds.keySet()];
        
        for(OpportunityAsset__c opAsset : optyAssets){
            opAsset.Opportunity__c = convertedOppIds.get(opAsset.Lead__c);
        }
        System.debug('optyAssets ' + optyAssets);
        if(!optyAssets.isEmpty() && optyAssets.size()>0){
            update optyAssets;
        }
        
        for(Opportunity_Coverage__c opCoverage : optyCoverage){
            opCoverage.Opportunity__c = convertedOppIds.get(opCoverage.Lead__c);
        }
        
        System.debug('optyCoverage ' + optyCoverage);
        if(!optyCoverage.isEmpty() && optyCoverage.size()>0){
            update optyCoverage;
        }
        
        LisT<OpportunityTeamMember> otmList = new List<OpportunityTeamMember>();
        for(Id optyId : convertedOppIds.values()){
            OpportunityTeamMember otmFab = new OpportunityTeamMember (OpportunityId = optyId,UserId = '0054P000009WU9Z',TeamMemberRole = 'NB Intake Associate');
            OpportunityTeamMember otmBing = new OpportunityTeamMember (OpportunityId = optyId,UserId = '0054P000008sGzQ',TeamMemberRole = 'NB Manager');
            OpportunityTeamMember otmRaj = new OpportunityTeamMember (OpportunityId = optyId,UserId = '0054P000009WVaG',TeamMemberRole = 'NB Underwriter');
            OpportunityTeamMember otmNimit = new OpportunityTeamMember (OpportunityId = optyId,UserId = '0054P000009WVap',TeamMemberRole = 'Quoting and Pricing Associate');
            OpportunityTeamMember otmNik = new OpportunityTeamMember (OpportunityId = optyId,UserId = '0054P000009VvSe',TeamMemberRole = 'BO - Policy Administrator');
            otmList.add(otmFab);
            otmList.add(otmBing);
            otmList.add(otmRaj);
            otmList.add(otmNimit);
            otmList.add(otmNik);
        }
        
        if(!otmList.isEmpty() && otmList.size()>0){
            insert otmList;
        }
    }   
}