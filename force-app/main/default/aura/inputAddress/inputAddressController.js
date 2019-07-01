({
    /**
     * Since:  01/31/208
     * Author: Incapsulate
     * 
    */
    doInit : function(component, event, helper) { 
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objectName = component.get("v.objectApiName");
        //component.set("v.country",component.getReference('v.objDetail.'+controllingFieldAPI));
        //component.set("v.province",component.getReference('v.objDetail.'+dependingFieldAPI));
        helper.fetchPicklistValues(component,objectName,controllingFieldAPI, dependingFieldAPI);
    },
    
   
})