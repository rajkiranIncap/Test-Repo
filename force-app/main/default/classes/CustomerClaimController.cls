public with sharing class CustomerClaimController {
	@TestVisible
    private CustomerClaimController()
    {
        //  nothing to do here...
    }
    
    
    @AuraEnabled
    public static List<InsuranceClaim__c> getClaims() {
        
        //Get Currently Logged in User details 
        
        //Get claim for Currently Logged in User. 
        List<InsuranceClaim__c> claims = [Select Id,PolicyNumberId__r.Universal_Policy_Number__c,InsuredAssetId__r.Street__c,InsuredAssetId__r.City__c,
                                          InsuredAssetId__r.Country__c,InsuredAssetId__r.State__c,InsuredAssetId__r.Zip_Code__c,
                                          Claim_Reason_Type__c,Loss_Date__c,LossType__c,Status__c from InsuranceClaim__c Limit 100];
                
        return claims;
        
    }
}