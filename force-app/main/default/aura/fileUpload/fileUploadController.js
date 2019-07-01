({
	myActionInit : function(component, event, helper) {
		var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        if(sPageURL){
            var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
            if(sURLVariables){
                var sParameterName;
                var i;
                for (i = 0; i < sURLVariables.length; i++) {
                    sParameterName = sURLVariables[i].split('='); //to split the key from the value.
        
                    if (sParameterName[0] === 'recordId') { //lets say you are looking for param name - firstName
                        sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
                        if(sParameterName[1]){
                            component.set("v.recordId",sParameterName[1]);
                        }
                    }
                }
            }
        }
	}
})