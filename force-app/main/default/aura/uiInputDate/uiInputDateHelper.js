/**
 * Since:  01/02/2019
 * Author: Rajkiran Dewara
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
               && re.test(daf)
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
                    if(eventVal instanceof Array && this.isValidDependencyId(component,event)){
                        for(var j=0;j<eventVal.length;j++){
                            if(valueArr[i] && valueArr[i].toString() == eventVal[j]){
                                this.isAttribute(component, event,attributename, ishide ? false:true); 
                                isVisibled = ishide ? false:true;
                            }
                        }
                    }else if(this.isValidDependencyId(component,event)
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
    setDefaultValueOfElementProperty : function(component,event,propertyname,propertyvalue,typeofpropertyyvalue){ 
        if(propertyvalue){
            var str="";
            if(typeof propertyvalue == "boolean"){
                str = propertyvalue.toString();
            }else{
                str = propertyvalue.toLowerCase();
            }
            if(propertyname.toLowerCase() == "pattern"){
                if(!str || str == "" || str == null){
                    propertyvalue = "*";
                }
            }else{
                var regex=/^\s*(true|1|on)\s*$/i;
                if (typeof str === 'string'){
                    propertyvalue = regex.test(str);
                }
            }
            component.getSuper().find("incapLightningInputEl").set("v."+propertyname, propertyvalue);
        }
    }
})