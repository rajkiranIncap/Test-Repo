/**
  * @author Incapsulate
  * @description Class used for fetching Content Document Link records. 
*/
public with sharing class BaseIC_ContentDocLinkHelper {
    /**
    * @description Method to get the Content Document Link records by Link Enitity Id
    * @param entityIds record Id
    * @return List of ontent Document Link
    **/
    public static List<ContentDocumentLink>  getRelatedFile (String entityIds)
    {
        Map<String, Object> mapParams = new Map<String, Object> ();
        mapParams.put('entityIds', entityIds);
        String getContentDocLinks =
                ' SELECT ' +                    
                    ' ContentDocument.LatestPublishedVersion.Id, ' +
                    ' ContentDocument.LatestPublishedVersion.ContentBodyId  , ' +
                    ' ContentDocument.LatestPublishedVersion.ContentDocumentId, ' +
                    ' ContentDocument.LatestPublishedVersion.Title, ' +
                    ' ContentDocument.LatestPublishedVersion.OwnerId, ' +
                    ' ContentDocument.LatestPublishedVersion.Owner.Name, ' +
                    ' ContentDocument.LatestPublishedVersion.ContentSize, ' +
                    ' ContentDocument.LatestPublishedVersion.PathOnClient, ' +
                    ' ContentDocument.LatestPublishedVersion.FileExtension, ' +
                    ' ContentDocument.LatestPublishedVersion.FileType, ' +
                    ' ContentDocument.LatestPublishedVersion.CreatedDate, ' +
                    ' ContentDocument.LatestPublishedVersion.LastModifiedDate, ' +
            		' ContentDocument.LatestPublishedVersion.Description, ' +
            		' ContentDocument.LatestPublishedVersion.Description__c, ' +
            		' ContentDocument.LatestPublishedVersion.Content_Type__c ' +
                ' FROM ' +
                    ' ContentDocumentLink ' +
                ' WHERE ' +
                    ' LinkedEntityId = :entityIds ';
        return Database.query(getContentDocLinks);        
    } 
}