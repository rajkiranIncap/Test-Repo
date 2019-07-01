/**
* @Author Incapsulate
* @Since 12-03-2019
* @Description: 
*/
public class RepeaterComponentWrapper {
    
        @AuraEnabled
        public RepeaterCard component;    
    
        @AuraEnabled
        public Map<String, Object> attributes;
    
        @AuraEnabled
        public List<RepeaterComponentWrapper> sections = new List<RepeaterComponentWrapper>();
    
        @AuraEnabled
        public String label;
        
       
        public RepeaterComponentWrapper(){}
            
        public RepeaterComponentWrapper(RepeaterCard component, Map<String, Object> attributes) {
            this.component = component;
            this.attributes = attributes;            
        }
        public RepeaterComponentWrapper(RepeaterComponentWrapper rcw, RepeaterCard component, Map<String, Object> attributes,List<RepeaterComponentWrapper> sectionsls) {
            this.sections = sectionsls;
        }
        public class RepeaterCard {
            @AuraEnabled
            public String Name;
            
            //below variables are used for formTable header part of the component.
            @AuraEnabled
            public String column1;
            @AuraEnabled
            public String column2;
            @AuraEnabled
            public String column3;
            @AuraEnabled
            public String column4;
            @AuraEnabled
            public String column5;
            @AuraEnabled
            public List<String> listOfColumn;
            
            @AuraEnabled
            public String formulaColumnName;
            @AuraEnabled
            public String formula;
            
            //below variable will have the developer name of the metadata
            @AuraEnabled
            public String metadataRecordDeveloperName;
            
            
        }
}