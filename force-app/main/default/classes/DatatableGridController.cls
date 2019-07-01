public class DatatableGridController {
	@AuraEnabled
    public static List<Account> getAccounts(){
        return [SELECT
               Id, Name, Phone, Rating
               FROM Account LIMIT 200];
    }

    @AuraEnabled
    public static boolean updateAccounts(List<Account> editedAccountList){
        try{
            update editedAccountList;
            return true;
        } catch(Exception e){
            return false;
        }
    }
}