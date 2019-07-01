({
	validate : function(component) {
		var components = component.get('v.components');
        var isValid = true, cmpValid;
        for(var index in components) {
            if(components[index].validate) {
                cmpValid = components[index].validate();
                console.log(cmpValid);
                isValid = cmpValid && isValid;
            }
        }
        
        return isValid;
	}
})