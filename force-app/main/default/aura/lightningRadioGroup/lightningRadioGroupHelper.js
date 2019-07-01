/**
 * Since:  06/05/2019
 * Author: Incapsulate
 * Generalizing the depedent component function as required based on attributes.
*/
({
	isValidDependencyId : function(component,event){
        var dependensOnIdsArray = component.get("v.dependsOnId").split(",");
        var validDependensOn = false;
        for(var i=0 ;i<dependensOnIdsArray.length;i++){
            validDependensOn = component.get("v.dependsOnId") 
                 && dependensOnIdsArray[i] == event.getParam("fieldValueObject").dependencyId;
            if(validDependensOn){
                break;
            }
        }
    	return validDependensOn;
	},
    //function to handle boolean true false for the attribute
    //handling isRender,required,disabled,readonly
    isAttribute : function(component,event,attributename,isattributevalue){
        component.set("v."+attributename,isattributevalue);  
    },
    skipLogic : function(component,event,valueId,eventVal,regexId,attributename,ishide){        
        if(component.get("v."+regexId)){ 
            var re = new RegExp(component.get("v."+valueId).toString());
            if(this.isValidDependencyId(component,event)
               && re.test(eventVal)
              ){
                this.isAttribute(component, event,attributename,true);
            }else if(this.isValidDependencyId(component,event)){
                this.isAttribute(component, event,attributename,false);        
            }
        }else{
            if(component.get("v."+valueId)){
                var value = component.get("v."+valueId).toString();
                var valueArr = value.split(",");
                var isVisibled = false;
                for(var i=0; i < valueArr.length;i++){
                    if(this.isValidDependencyId(component,event)
                       && valueArr[i].toString() == eventVal){
                        this.isAttribute(component, event,attributename, ishide ? false:true); 
                        isVisibled = ishide ? false:true;
                    }
                }
                if(this.isValidDependencyId(component,event) && !isVisibled && !ishide){
                     this.isAttribute(component, event,attributename,false);        
                }
            }
        }
    },
     //<!-- 06/05/2019 Incapsulate Added function for depedent skip logic-->
    onInputChange : function(component, event){       
        var value = event.getSource().get("v.value");       
        if(component.get("v.dependencyId")){
            var appEvent = $A.get("e.c:onChangeApplicationEvent");
            appEvent.setParams({
                "fieldValueObject":{
                    "dependencyId" : component.get("v.dependencyId"),
                    "dependsOnId" : component.get("v.dependsOnId"),
                    "dependsOnValue" : value
                }
            });
            appEvent.fire();
        } 
        
        var appSyncEvent = $A.get("e.c:eventToSyncSobject");
        appSyncEvent.setParams({
            "FormDetailObject":{
                "relatedSobject" : component.get("v.genericObjectValue"),//repeaterCardController line 26
                "indexVal" : component.get("v.indexVal"),
                "parentFieldName" : component.get("v.parentFieldName"),
                "validityKey" : event.getSource().get("v.name"),
                "validityValue" : component.find("incapLightningRadioGroupEl").reportValidity()
            }
        });
        appSyncEvent.fire();             
    },
})