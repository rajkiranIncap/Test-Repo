public without sharing class SendDocuSignAction {

    @TestVisible
    private SendDocuSignAction() {}
    
    public class Request {
        @InvocableVariable(label='DocuSign Template Name' required=true)
        public String templateName;
        @InvocableVariable(label='Recipient Name' required=true)
        public String recipientName;
        @InvocableVariable(label='Recipient Email' required=true)
        public String recipientEmail;
        @InvocableVariable(label='Recipient Embedded Signing ID' required=false)
        public String recipientClientUserId;
        @InvocableVariable(label='Embedded Signing Finish URL' required=false)
        public String finishUrl;
        @InvocableVariable(label='SObject Merge IDs' required=false)
        public List<String> recordIds;
    }
    
    @InvocableMethod(label='Send DocuSign Envelope' description='')
    public static void execute(List<Request> requests) {
        if(!requests.isEmpty()) {
            sendFuture(requests[0].finishUrl,
                requests[0].templateName,
                requests[0].recipientName,
                requests[0].recipientEmail,
                requests[0].recipientClientUserId,
                requests[0].recordIds);
        }
    }
    
    @future(callout=true)
    public static void sendFuture(String finishUrl, String templateName, String recipientName, String recipientEmail, String recipientClientUserId, List<String> recordIds) {
        DocuSignUtil.getTemplateSignUrlBase(
            finishUrl,
            templateName,
            recipientName,
            recipientEmail,
            recipientClientUserId,
            recordIds,
            null,
            null);
    }
}