public class GetRecordId {
    @InvocableMethod(label='Get Id')
    public static list<string> recordid(){
       String ids =  ApexPages.currentPage().getParameters().get('IncomingPolicyID');
        return new list<String> {ids};
    }

}