public class PartnerClaim {
    @AuraEnabled
    public static List<Case> getClaims() {
        
        //Get Currently Logged in User details 
        
        //Get claim for Currently Logged in User. 
        List<Case> claims = [Select Id,CaseNumber,Date_Care_Started__c,Date_Care_Ended__c,Status from Case Limit 100];
        return claims;
        
    }

}