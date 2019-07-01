public with Sharing class CustomerPolicyController {
	
    @TestVisible
    private CustomerPolicyController()
    {
        //  nothing to do here...
    }
    
    
    @AuraEnabled
    public static List<InsurancePolicy__c> getPolicies() {
        
        //Get Currently Logged in USer details 
        //Get Policy for Currently Logged in Users. 
        List<InsurancePolicyParticipant__c> policyParticipantList = [Select Id,Policy__c,Account__c from InsurancePolicyParticipant__c Limit 100];
        Set<Id>policyIdset = new Set<ID>();
        for(InsurancePolicyParticipant__c pp : policyParticipantList){
            policyIdset.add(pp.Policy__c);
        }
        List<InsurancePolicy__c> policies = [Select Id,Name,Is_Active__c,Policy_Name__c,Policy_Type__c,Expiration_Date__c,Universal_Policy_Number__c from InsurancePolicy__c where Is_Active__c = true  AND Id In:policyIdset  Limit 100];
                
        return policies;
        
    }
    
    @AuraEnabled
    public static String getPolicyType(id policyId) {
        
        String TypeToReturn;
        List<InsurancePolicy__c> policyList = [Select Id,Policy_Type__c from InsurancePolicy__c where Id =: policyId];
        
        if(!policyList.isEmpty()){
			TypeToReturn = policyList[0].Policy_Type__c;            
        }
        
        return TypeToReturn;
    }
    
}