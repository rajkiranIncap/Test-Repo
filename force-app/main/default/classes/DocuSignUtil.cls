/**
 * (c) Incapsulate
 * Name         : 	LTC_DocuSignUtil
 * Description  : 	Utility class for calling SOAP WSDL2Apex for DocuSign
 * 					integration.
 * Created Date: 02/02/2018
 * Created By: Will Lin
 * 
 * Modification Log
 * ---------------------------------------------
 * Date                 Developer           Description 
 * ----------           --------------      ---------------
 * 03/28/2018           Nikunj Vedia        Removed Exception Handling
 *                                          to make it Use Case Specific
 * 04/06/2018			Will Lin			Added approved form number
 *                                          as custom field based on template name
 * 05/07/2018			Will Lin			US32643
 *                                          Added method to update case status
 * 07/17/2018           NIkunj Vedia        Removed manual exception throw
 **/
public with sharing class DocuSignUtil {
    
    private static string integrationKey = 'bc910a4c-9fa8-4474-9950-09a5408c3556';
    private static string docusignAccountId = '798642be-44ff-4ecf-a9e1-d8a7ea8482de';
    private static string serverUrl = 'callout:DocuSign';
    private static string traceValue = 'SFDC_001_SOAP_embedded_signing';
    private static string traceKey = 'X-ray';
    private static DocuSignTK.APIServiceSoap apiSender;
    private static Map<String, DocuSignTK.EnvelopeTemplateDefinition> nameToTemplate;
    private static final String CLASS_NAME = 'LTC_DocuSignUtil';
    
    /**
	 * Constructor for SonarQube
	 **/
    @TestVisible
    private DocuSignUtil(){}
    
    /**
	 * Initializes variables used for DocuSign API and returns
	 * DocuSign API handle.
	 * @Return	DocuSignTK.APIServiceSoap
	 **/
    private static DocuSignTK.APIServiceSoap intialize() {
        //set callout headers with merge fields from named credential
        DocuSignTK.APIServiceSoap apiSender = new DocuSignTK.APIServiceSoap();
        apiSender.endpoint_x = serverUrl;
        apiSender.timeout_x = 60000;
        apiSender.inputHttpHeaders_x = new Map<String, String>();
        String auth =   '<DocuSignCredentials><Username>{!$Credential.Username}</Username>' 
            + '<Password>{!$Credential.Password}</Password>' 
            + '<IntegratorKey>' + integrationKey + '</IntegratorKey></DocuSignCredentials>';
        apiSender.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
        apiSender.inputHttpHeaders_x.put(traceKey, traceValue);
        
        //get all templates by template name
        DocuSignTK.EnvelopeTemplates docusignTemplates = apiSender.RequestTemplates(docusignAccountId, true);
        
        nameToTemplate = new Map<String, DocuSignTK.EnvelopeTemplateDefinition>();
        for(DocuSignTK.EnvelopeTemplateDefinition template : docusignTemplates.EnvelopeTemplateDefinition) {
            nameToTemplate.put(template.Name, template);
        }
        
        return apiSender;
    }
    
    private static DocuSignTK.EnvelopeInformation getEnvelopeInformation(List<String> recordIds){

        DocuSignTK.EnvelopeInformation envelopeInfo = new DocuSignTK.EnvelopeInformation();
        envelopeInfo.AccountId = docusignAccountId;
        
        if(recordIds != null && !recordIds.isEmpty()) {
            envelopeInfo.CustomFields = new DocuSignTK.ArrayOfCustomField();
            envelopeInfo.CustomFields.CustomField = new List<DocuSignTK.CustomField>();
            
            for(String strId : recordIds) {
                Id recId = strId;
                DocuSignTK.CustomField customField = new DocuSignTK.CustomField();
                customField.Name = '##SF' + recId.getSobjectType().getDescribe().getName();
                customField.Value = recId;
                envelopeInfo.CustomFields.CustomField.add(customField);
            }
        }

        return envelopeInfo;
    }

    private static DocuSignTK.ArrayOfCompositeTemplate getArrayOfCompositeTemplate(String templateName, String signerName, String signerEmail, String signerId, Map<String, String> customFields, List<Id> attachIds){

        DocuSignTK.CompositeTemplate template = new DocuSignTK.CompositeTemplate();
        //add server template by name
        DocuSignTK.ServerTemplate serverTemplate = new DocuSignTK.ServerTemplate();
        serverTemplate.Sequence = 1;
        serverTemplate.TemplateID = nameToTemplate.get(templateName).TemplateID;
        
        template.ServerTemplates = new DocuSignTK.ArrayOfServerTemplate();
        template.ServerTemplates.ServerTemplate = new List<DocuSignTK.ServerTemplate>();
        template.ServerTemplates.ServerTemplate.add(serverTemplate);
        
        //specify the recipient, setting the client user id for embedded sign
        DocuSignTK.Recipient recipient = new DocuSignTK.Recipient();
        recipient.Email = signerEmail;
        recipient.UserName = signerName;
        recipient.ID = 1;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = 1;
        recipient.CaptiveInfo = new DocuSignTK.RecipientCaptiveInfo();
        recipient.CaptiveInfo.ClientUserID = signerId;
        recipient.RoleName = 'Signer 1';
        
        //add inline template, which is the overlay for the recipients
        DocuSignTK.Envelope envelope = new DocuSignTK.Envelope();
        envelope.Recipients = new DocuSignTK.ArrayOfRecipient();
        envelope.Recipients.Recipient = new List<DocuSignTK.Recipient>();
        envelope.Recipients.Recipient.add(recipient);
        envelope.AccountId = docusignAccountId;
        
        //add custom fields to envelope from field map
        if(customFields != null) {
            for(String fieldName : customFields.keySet()) {
                DocuSignTK.Tab customField = new DocuSignTK.Tab();
                customField.Name = fieldName;
                customField.TabLabel = fieldName;
                customField.Value = customFields.get(fieldName);
                customField.Type_x = 'Custom';
                customField.RecipientID = 1;
                if(envelope.Tabs == null) {
                    envelope.Tabs = new DocuSignTK.ArrayOfTab();
                    envelope.Tabs.Tab = new List<DocuSignTK.Tab>();
                }
                envelope.Tabs.Tab.add(customField);
            }
        }
        
        DocuSignTK.InlineTemplate inlineTemplate = new DocuSignTK.InlineTemplate();
        inlineTemplate.Sequence = 1;
        inlineTemplate.Envelope = envelope;
        
        template.InlineTemplates = new DocuSignTK.ArrayOfInlineTemplate();
        template.InlineTemplates.InlineTemplate = new List<DocuSignTK.InlineTemplate>();
        template.InlineTemplates.InlineTemplate.add(inlineTemplate);
        
        DocuSignTK.ArrayOfCompositeTemplate compositeTemplates = new DocuSignTK.ArrayOfCompositeTemplate();
        compositeTemplates.CompositeTemplate = new List<DocuSignTK.CompositeTemplate>();
        
        return populateCompositeTemplates(compositeTemplates,recipient,template,attachIds);
    }
    /**
    *
    **/
    private static DocuSignTK.ArrayOfCompositeTemplate populateCompositeTemplates(DocuSignTK.ArrayOfCompositeTemplate compositeTemplates,DocuSignTK.Recipient recipient,DocuSignTK.CompositeTemplate template,List<Id> attachIds){

        if(attachIds != null && !attachIds.isEmpty()) {
            List<Attachment> attachments = [SELECT Id, Name, Body FROM Attachment WHERE Id IN :attachIds];
            for(Attachment att : attachments) {
                DocuSignTK.CompositeTemplate attachTemplate = new DocuSignTK.CompositeTemplate();
                
                //add inline template, which is the overlay for the recipients
                DocuSignTK.Envelope attachEnvelope = new DocuSignTK.Envelope();
                attachEnvelope.Recipients = new DocuSignTK.ArrayOfRecipient();
                attachEnvelope.Recipients.Recipient = new List<DocuSignTK.Recipient>();
                attachEnvelope.Recipients.Recipient.add(recipient);
                attachEnvelope.AccountId = docusignAccountId;
                
                //add up to 4 auto anchors to mimic OOB DocuSign for Salesforce
                attachEnvelope.Tabs = new DocuSignTK.ArrayOfTab();
                attachEnvelope.Tabs.Tab = new List<DocuSignTK.Tab>();
                for(Integer j = 0; j < 4; j++) {
                    DocuSignTK.Tab anchorSign = new DocuSignTK.Tab();
                    anchorSign.Name = 'Anchor_Sign_' + (j + 1);
                    anchorSign.TabLabel = 'Anchor_Sign_' + (j + 1);
                    anchorSign.Type_x = 'SignHere';
                    anchorSign.RecipientID = j + 1;
                    anchorSign.AnchorTabItem = new DocuSignTK.AnchorTab();
                    anchorSign.AnchorTabItem.AnchorTabString = '\\s' +  + (j + 1) + '\\';
                    anchorSign.AnchorTabItem.Unit = 'Pixels';
                    anchorSign.AnchorTabItem.XOffset = 0;
                    anchorSign.AnchorTabItem.YOffset = 0;
                    anchorSign.AnchorTabItem.IgnoreIfNotPresent = true;
                    
                    DocuSignTK.Tab anchorName = new DocuSignTK.Tab();
                    anchorName.Name = 'Anchor_Name_' + (j + 1);
                    anchorName.TabLabel = 'Anchor_Name_' + (j + 1);
                    anchorName.Type_x = 'FullName';
                    anchorName.RecipientID = j + 1;
                    anchorName.AnchorTabItem = new DocuSignTK.AnchorTab();
                    anchorName.AnchorTabItem.AnchorTabString = '\\n' + (j + 1) + '\\';
                    anchorName.AnchorTabItem.Unit = 'Pixels';
                    anchorName.AnchorTabItem.XOffset = 0;
                    anchorName.AnchorTabItem.YOffset = 0;
                    anchorName.AnchorTabItem.IgnoreIfNotPresent = true;
                    
                    DocuSignTK.Tab anchorDate = new DocuSignTK.Tab();
                    anchorDate.Name = 'Anchor_Date_' + (j + 1);
                    anchorDate.TabLabel = 'Anchor_Date_' + (j + 1);
                    anchorDate.Type_x = 'DateSigned';
                    anchorDate.RecipientID =  j + 1;
                    anchorDate.AnchorTabItem = new DocuSignTK.AnchorTab();
                    anchorDate.AnchorTabItem.AnchorTabString = '\\d' + (j + 1) + '\\';
                    anchorDate.AnchorTabItem.Unit = 'Pixels';
                    anchorDate.AnchorTabItem.XOffset = 0;
                    anchorDate.AnchorTabItem.YOffset = 0;
                    anchorDate.AnchorTabItem.IgnoreIfNotPresent = true;
                    
                    attachEnvelope.Tabs.Tab.add(anchorSign);
                    attachEnvelope.Tabs.Tab.add(anchorName);
                    attachEnvelope.Tabs.Tab.add(anchorDate);
                }
                
                DocuSignTK.InlineTemplate attachInlineTemplate = new DocuSignTK.InlineTemplate();
                attachInlineTemplate.Sequence = 1;
                attachInlineTemplate.Envelope = attachEnvelope;
                
                attachTemplate.InlineTemplates = new DocuSignTK.ArrayOfInlineTemplate();
                attachTemplate.InlineTemplates.InlineTemplate = new List<DocuSignTK.InlineTemplate>();
                attachTemplate.InlineTemplates.InlineTemplate.add(attachInlineTemplate);
                
                DocuSignTK.Document attachDocument = new DocuSignTK.Document();
                attachDocument.ID = 1;
                attachDocument.Name = att.Name;
                attachDocument.FileExtension = 'pdf';
                attachDocument.PDFBytes = EncodingUtil.base64Encode(att.Body);
                attachTemplate.Document = attachDocument;
                
                compositeTemplates.CompositeTemplate.add(attachTemplate);
            }
        }

        compositeTemplates.CompositeTemplate.add(template);

        return compositeTemplates;
    }
    /**
     * Base method for calling DocuSign API and getting the embedded signing URL. 
     * @Param	finishUrl - URL redirect upon DocuSign action
     * 			templateName - name of template as configured in DocuSign
     * 			signerName - signer full name
     * 			signerEmail - signer email address
     * 			signerId - signer unique id
     * 			recordId - the record Id to be used in merge fields
     * 			customFields - map of key-value pairs 
     *                         to add as CustomField nodes
     * 			recordIds - optional list of records to use for 
     *                      merging multiple objects/records
     * @Return	String
     **/
    public static String getTemplateSignUrlBase(String finishUrl, String templateName, String signerName, String signerEmail, String signerId, List<String> recordIds, Map<String, String> customFields, List<Id> attachIds) {
        //initialize sender
        if(apiSender == null) { apiSender = intialize(); }
        
        //1. envelope information
        DocuSignTK.EnvelopeInformation envelopeInfo = getEnvelopeInformation(recordIds);
        
        //2. composite template
        DocuSignTK.ArrayOfCompositeTemplate compositeTemplates = getArrayOfCompositeTemplate(templateName, signerName, signerEmail, signerId, customFields, attachIds);

        //3. create envelope in non-draft status
        DocuSignTK.EnvelopeStatus result = apiSender.CreateEnvelopeFromTemplatesAndForms (
            envelopeInfo, 
            compositeTemplates,
            true);
        String envelope_id = result.EnvelopeID;
        
        if(String.isBlank(signerId)) {
            //apiSender.SendEnvelope(envelope_id, docusignAccountId);
            return null;
        }
        else {
            //4. get recipient url
            DocuSignTK.RequestRecipientTokenAuthenticationAssertion assertion = 
                new DocuSignTK.RequestRecipientTokenAuthenticationAssertion();
            assertion.AssertionID = signerId;
            assertion.AuthenticationInstant = Datetime.now();
            assertion.AuthenticationMethod = 'Password';
            assertion.SecurityDomain = CLASS_NAME;
            
            //set return urls for each outcome
            DocuSignTK.RequestRecipientTokenClientURLs urls = new DocuSignTK.RequestRecipientTokenClientURLs();
            String baseFinishUrl = finishUrl;
            //append if finish url already has parameters
            if (baseFinishUrl.contains('?')) { baseFinishUrl += '&event='; }
            else { baseFinishUrl += '?event='; }
            
            urls.OnSigningComplete  = baseFinishUrl + 'signing_complete';
            urls.OnViewingComplete  = baseFinishUrl + 'viewing_complete';
            urls.OnCancel           = baseFinishUrl + 'cancel';
            urls.OnDecline          = baseFinishUrl + 'decline';
            urls.OnSessionTimeout   = baseFinishUrl + 'session_timeout';
            urls.OnTTLExpired       = baseFinishUrl + 'ttl_expired';
            urls.OnException        = baseFinishUrl + 'exception';
            urls.OnAccessCodeFailed = baseFinishUrl + 'failed_access_code';
            urls.OnIdCheckFailed    = baseFinishUrl + 'failed_id_check';
            urls.OnFaxPending       = baseFinishUrl + 'fax_pending';
            
            //get the url
            return apiSender.RequestRecipientToken(
                envelope_id, signerId, signerName, signerEmail, assertion, urls);
        }
    }
    
    /**
     * Updates Case status and sub status
     * @Param recordId - case record Id
     **/
    @AuraEnabled
    public static void updateSignedCase(Id recordId) {
        
        Case caseObj = [
            SELECT Id, Status, Reason
            FROM Case 
            WHERE Id = :recordId
            LIMIT 1
        ];
        
        caseObj.Status = 'Closed';
        caseObj.Reason = 'DocuSign Util';
        
        update caseObj;
        
    }
}