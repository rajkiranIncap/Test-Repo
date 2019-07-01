({
	doInit : function(component, event, helper) {
		var formateddate = $A.localizationService.formatDate(new Date(), component.get("v.format"));        
	},
    
    validatedate : function(component, event, helper) {
		var datecmp = component.find("inputDateTime");
        var dateval = component.get("v.value");
        var errormsg = component.get("v.errorMsg");
        var dateobj = new Date(dateval);
        if(dateobj.toString() =="Invalid Date"){
            datecmp.set("v.errors", [{message:errormsg+" "+component.get("v.format")}]);
        }else{
            datecmp.set("v.errors", null);            
        }
        
	}
})