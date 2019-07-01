/**
* @Author Incapsulate
* @Since 21-06-2019
* @Description:Test Class for FileRelatedList
*/

@isTest
public class FileRelatedListTest {
    
    /**
    * @Author Incapsulate
    * @Since 21-06-2019
    * @Description:Test Class for deleteDocument,saveDocumentAdditionalDetail,deleteDocument,getBaseUrl method of FileRelatedList class.
    */
    @isTest
    public static void TestClassMethod()
    {
        
        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        List<Map<String, Object>> lstrelatedfile = FileRelatedList.getRelatedFiles(string.valueOf(acct.Id));
        system.assertEquals(false, lstrelatedfile.size()>1 );
        
        string st = '{"fileDescription": "Hello World","fileTitle" : "Test"}';
        FileRelatedList.saveDocumentAdditionalDetail(string.valueOf(documents[0].Id), st);
        List<ContentDocument> saveConDocuments = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        system.assertEquals(false, saveConDocuments.size() > 1);
        
        string sturl = FileRelatedList.getBaseUrl();
        system.assertEquals(true,string.isNotBlank(sturl));
        
        
        FileRelatedList.deleteDocument(string.valueOf(documents[0].Id));
        List<ContentDocument> condocuments = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        system.assertEquals(false, condocuments.size() > 1);
        
        
    }
    
}