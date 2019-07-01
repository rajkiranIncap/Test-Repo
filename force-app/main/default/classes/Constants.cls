/**
* @Author Incapsulate
* @Since 12-03-2019
* @Description: 
*/
public class Constants {
    public static Map<String,String> mapOfPluralName {
        get {
            if(mapOfPluralName == null){
                mapOfPluralName = new Map<String,String>{
                    'Opportunity' => 'Opportunities'
                };
             }
        	return mapOfPluralName;    
        }
        set;
	}    
}