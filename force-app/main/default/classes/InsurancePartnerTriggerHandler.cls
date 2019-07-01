public without sharing class InsurancePartnerTriggerHandler {
    public static void createInsurancePolicy(List<insurance_partner__e> insurancePolicyList){
        Set<string> productNameSet = new Set<string>();
        Set<string> userNameSet = new Set<string>();
        
        for(insurance_partner__e insurancePartner : insurancePolicyList){
            productNameSet.add(insurancePartner.Product_Name__c);
            userNameSet.add(insurancePartner.NB_Intake_User__c);
        }
        
        List<Product2> productList = [select Id, Name from Product2 where Name in : productNameSet];
        List<User> userList = [select Id, Name, UserName from User where UserName in : userNameSet];
        
        Map<string, Product2> productMap = new Map<string, Product2>();
        Map<string, User> userMap = new Map<string, User>();
        
        for(Product2 product : productList){
            productMap.put(product.Name, product);
        }
        
        for(User userDetail : userList){
            userMap.put(userDetail.UserName, userDetail);
        }
        for(insurance_partner__e insurancePartner : insurancePolicyList){
            InsurancePolicy__c insurnacePolicy = new InsurancePolicy__c();
            insurnacePolicy.Name = insurancePartner.Policy_Number__c;
            insurnacePolicy.Universal_Policy_Number__c = integer.valueof(insurancePartner.Policy_Number__c);
            insurnacePolicy.Policy_Type__c = insurancePartner.Policy_Type__c;
            insurnacePolicy.Effective_Date__c = insurancePartner.Effective_Date__c;
            insurnacePolicy.Expiration_Date__c = insurancePartner.Expiration_date__c;
            insurnacePolicy.External_ID__c = insurancePartner.External_Id__c;
            insurnacePolicy.Status__c = insurancePartner.Status__c;
            insurnacePolicy.Product__c = productMap.get(insurancePartner.Product_Name__c).Id;
            insurnacePolicy.NB_Intake_User__c = userMap.get(insurancePartner.NB_Intake_User__c).Id;
            
            insert insurnacePolicy;
        }
    }
}