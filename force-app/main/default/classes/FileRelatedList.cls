/**
* @author Incapsulate
* @description Class used for fetching related file. Being used by FileUpload Lighting component
*/
public with sharing class FileRelatedList {
    
    /**
    * @description Queries Content Document Link.
    * @param  - String entityIds - record Ids for which content documents link have to be retrieved
    * @return - List<Map<String, Object>> - returns List of content documents link records
    **/
    @AuraEnabled
    public static List<Map<String, Object>> getRelatedFiles( String entityIds) {
        List<Map<String, Object>> files = new List<Map<String, Object>>();
        try {          
            
            if (! String.isEmpty(entityIds) ) {
                
                // since we can't group by system dates or some fields on content version
                // then having to use a set to identify the unique files out of all the shared links
                Set<ContentVersion> contentVersions = new Set<ContentVersion>();
                //Fetching ContentDocumentLink Records
                List<ContentDocumentLink> contentDocList = ContentDocLinkHelper.getRelatedFile(entityIds);
                
                for ( ContentDocumentLink cdl : contentDocList ) {
                    contentVersions.add( cdl.ContentDocument.LatestPublishedVersion );
                }
                
                // once we have the unique files then add to a list of wrapper classes
                // that implements our custom sorting logic since any order by in soql
                // is rendered useless by having had to dedupe with a set
                List<ContentVersionWrapper> wrappers = new List<ContentVersionWrapper>();
                for ( ContentVersion cv : contentVersions ) {
                    wrappers.add( new ContentVersionWrapper( cv ) );
                }
                wrappers.sort();
                
                // I want to send back custom data along with the sobject, but I also
                // don't want to create another helper class since we only need this structure
                // when serializing the data back to our Lightning Component, so just using a map.
                for ( ContentVersionWrapper wrapper : wrappers ) {
                    files.add( new Map<String, Object>{
                        'Id' => wrapper.file.Id,
                            'ContentDocumentId' => wrapper.file.ContentDocumentId,
                            'ContentBodyId' => wrapper.file.ContentBodyId,
                            'Title' => wrapper.file.Title,
                            'OwnerId' => wrapper.file.OwnerId,
                            'OwnerName' => wrapper.file.Owner.Name,
                            'ContentSize' => wrapper.file.ContentSize,
                            'HumanReadableContentSize' => getHumanReadableByteCount( wrapper.file.ContentSize ),
                            'PathOnClient' => wrapper.file.PathOnClient,
                            'FileExtension' => wrapper.file.FileExtension,
                            'FileType' => wrapper.file.FileType,
                            'FileTypeIconName' => 'doctype:attachment',
                            'CreatedDate' => wrapper.file.CreatedDate,
                            'CreatedDateTimestamp' => wrapper.file.CreatedDate.getTime(),
                            'LastModifiedDate' => wrapper.file.LastModifiedDate,
                            'LastModifiedDateTimestamp' => wrapper.file.LastModifiedDate.getTime(),
                            'Description' => wrapper.file.Description__c,
                            'ContentType' => wrapper.file.Content_Type__c
                            });
                }
            }
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        return files;
    }
    
    /**
    * @description To get deleted the ContentDocument record
    * @param recordId ContentDocument record Id
    * @return void
    */
    @AuraEnabled
    public static void deleteDocument(Id recordId){
        Map<String,Object> mapParams = new Map<String,Object>();
        mapParams.put('recordId', recordId);
        string queryString ='SELECT Id FROM ContentDocument WHERE Id = :recordId' ;
        List<ContentDocument> entries = Database.query(queryString);
        Database.delete(entries);
    }
    
    /**
    * @description To get deleted the ContentDocument record
    * @param recordId ContentDocument record Id
    * @return void
    */
    @AuraEnabled
    public static void saveDocumentAdditionalDetail(Id recordId, String jsonString){
        FileDetails fd = (FileDetails)JSON.deserialize(jsonString, FileDetails.class);
        Map<String,Object> mapParams = new Map<String,Object>();
        mapParams.put('recordId', recordId);
        string queryString = 'SELECT Id, ContentDocumentId, VersionNumber, Content_Type__c, Description__c FROM ContentVersion where ContentDocumentId = :recordId order by VersionNumber LIMIT 1';
        List<ContentVersion> entries = Database.query(queryString);
        if(entries != null && entries.size() == 1){
            entries[0].Content_Type__c = fd.fileType;
            entries[0].Description__c  = fd.fileDescription ;
            Database.update(entries);
        }
        
    }
    
    /**
    * @description Queries Content Document Link.
    * @param  - size in decimal to round off
    * @return - String rounded figure size value
    **/
    private static String getHumanReadableByteCount( Decimal size ) {
        
        if ( size <= 0 ) {
            return '0';
        }
        
        String[] units = new String[] { 'B', 'KB', 'MB', 'GB', 'TB', 'EB' };
            Integer digitGroups = (Integer) ( Math.log( size ) / Math.log( 1024 ) );
        Decimal value = ( size / Math.pow( 1024, digitGroups ) ).setScale( 0, RoundingMode.DOWN );
        String text = String.valueOf( value ) + units[digitGroups];
        
        return text;
    }
    
    /**
    * @description This call is to sort as per file size
    **/    
    private class ContentVersionWrapper implements Comparable {
        
        public ContentVersion file { get; set; }
        
        public ContentVersionWrapper( ContentVersion file ) {
            this.file = file;
        }
        
        public Integer compareTo( Object other ) {
            return 1;
        }        
    }

    /**
    * @description To get org base url
    * @return - String Base url of org
    **/
    @AuraEnabled(cacheable=true)
    public static String getBaseUrl() {
        String baseUrl = '';
        try {
            baseUrl = system.URL.getSalesforceBaseUrl().toExternalForm();
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        return baseUrl;
    }
    
    public class FileDetails {
        @AuraEnabled
        public String fileDescription;
        
        @AuraEnabled
        public String fileTitle;
        
        @AuraEnabled
        public String fileType;
    }
}