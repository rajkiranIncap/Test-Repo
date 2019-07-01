public class SignatureCaptureController {
	@AuraEnabled
    public static Blob saveSignature(String signatureBody){
       Attachment a = new Attachment();
        a.ParentId = 'a097F00000765JA'; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/png';
        a.Name = 'Signature Capture.png';
        insert a;
        return EncodingUtil.base64Decode(signatureBody);
    }
}