public class CustomMetadataCollector {
    public static List<Lightning_Element_Detail__mdt> listOfElDetail {
        get{
            if(listOfElDetail == null){
               listOfElDetail = [Select Id, Lightning_Component_Name__c, QualifiedApiName, Label, DeveloperName from Lightning_Element_Detail__mdt];
            }
            return listOfElDetail;
        }
        set;
    }    
    
    public static List<CustomMetadata> getCustomMetadata(String searchString){
        List<CustomMetadata> listOfMetaData = new List<CustomMetadata>();
        for(Lightning_Element_Detail__mdt eldetail: listOfElDetail){
            if(eldetail.Lightning_Component_Name__c.contains(searchString)){
                CustomMetadata cm  = new CustomMetadata();
                cm.displayText = eldetail.Lightning_Component_Name__c;
                cm.value = eldetail.Id;
                listOfMetaData.add(cm);
            }
        }
        return listOfMetaData;
    }
    
    
    public class CustomMetadata{
        public String displayText;
        public String value;
    }
}