({
    /**
     * Since:  01/05/2019
     * Author: Incapsulate
     * Description: Dynamically preparing the row column components.
    */
	prepareItems : function(component, values) {
        var listToCreate = [];
        var toCreate = component.get('v.toCreate');
        var cardColumns = component.get('v.cardColumns');
        var cardTitle = component.get('v.cardTitle');
        var cardDescription = component.get('v.cardDescription');
        var cardIcon = component.get('v.cardIcon');
        var deleteIcon = component.get('v.deleteIcon');
        var metadataRecordDeveloperFieldName = component.get('v.metadataRecordDeveloperName');
        var attributes = {};
        if(toCreate) {
            attributes.toCreate = toCreate;
        }
        if(cardColumns) { attributes.columns = cardColumns; }
        if(cardTitle) { attributes.title = cardTitle; }
        if(cardDescription) { attributes.description = cardDescription; }
        if(cardIcon) { attributes.cardIcon = cardIcon; }
        if(deleteIcon) { attributes.deleteIcon = deleteIcon; }
        //attributes.value =  component.get('v.objectVal');
        attributes.parentFieldName = component.get('v.parentFieldName');
        var listToCreate = [],attributes,cmpName ;
       		var incrementindex = 0;
        	var rowincrementindex = 0;
        var objectValListVar = [];    
        for(var index in toCreate) {                
			    var columnindex = toCreate[index].sections[0].component.listOfColumn.length; 
                if(!component.get('v.formulaColumnName')){
                    component.set('v.formulaColumnName',toCreate[index].sections[0].component.formulaColumnName);
                    if(!component.get('v.formula')){
                    	component.set('v.formula',toCreate[index].sections[0].component.formula);
                    }
                }
                cmpName = toCreate[index].sections[0].component.Name;
                attributes = toCreate[index].sections[0].attributes;                
                if(columnindex > incrementindex ){
                    incrementindex = incrementindex+1;
                    attributes["aura:id"] = "row"+rowincrementindex+"_column"+incrementindex;
                	attributes.name = "row"+rowincrementindex+"_column"+incrementindex;
                }else{
                    rowincrementindex = rowincrementindex+1;
                    incrementindex = 0;
                    incrementindex = incrementindex+1;
                    attributes["aura:id"] = "column_"+incrementindex;
                	attributes.name = "column_"+incrementindex;
                }           
                
                if(attributes.fieldBinding) {
                    if(component.get("v.objectValList")){
                        var existingindexval = component.get("v.objectValList");
                        if(existingindexval[rowincrementindex]){
                        	objectValListVar[rowincrementindex] =  existingindexval[rowincrementindex];   
                        }else{
                            var objectva = {"attributes":{type: component.get("v.objectType"), url:"/services/data/v45.0/sobjects/"+component.get("v.objectType")},metadataRecordDeveloperFieldName:toCreate[index].sections[0].component.metadataRecordDeveloperName};                
                            component.set("v.objectVal", objectva);
                            component.set("v.value", JSON.stringify(component.get("v.objectVal")));
                            objectValListVar[rowincrementindex]=component.get("v.objectVal");
                            component.set("v.objectValList",objectValListVar);
                        }
                    }else{
                        var objectva = {"attributes":{type: component.get("v.objectType"), url:"/services/data/v45.0/sobjects/"+component.get("v.objectType")},metadataRecordDeveloperFieldName:toCreate[index].sections[0].component.metadataRecordDeveloperName};                
                        component.set("v.objectVal", objectva);
                        component.set("v.value", JSON.stringify(component.get("v.objectVal")));
                        objectValListVar[rowincrementindex]=component.get("v.objectVal");
                        component.set("v.objectValList",objectValListVar);
                    }
                    attributes.value = component.getReference('v.objectValList['+rowincrementindex+'].'+attributes.fieldBinding);
                    //below if condition to avoid the application event fire while rendering the data table with values.
                    var isRecordModified = false;
                    if(attributes.value && attributes.fieldBinding && objectValListVar[rowincrementindex][attributes.fieldBinding]){
                        //below condition to handle whether the page is loading first time to insert the data
                        //than allow user to enter the data once the data saved in the data while modifing record
                        //user will not be able to modified the disabled or readonly field.
                        if(objectValListVar[rowincrementindex] && objectValListVar[rowincrementindex].Id){
                            isRecordModified = true
                        }else if(attributes.disabled || attributes.readonly){
                            //attributes.disabled = false;
                            //attributes.readonly = false;
                        }
                       this.handleColumnValueSync(component,event,attributes.name,objectValListVar[rowincrementindex][attributes.fieldBinding],isRecordModified);
                    }
                }
            	if(attributes.fieldBinding && objectValListVar[rowincrementindex] && objectValListVar[rowincrementindex].Id){
                    isRecordModified = true
                }else if(attributes.fieldBinding &&  (attributes.disabled || attributes.readonly)){
                    //attributes.disabled = false;
                    //attributes.readonly = false;
                }
                listToCreate.push([cmpName, attributes]);
            	
            }
		$A.createComponents(
            listToCreate,
            function(cmps, status, error){
                if (status === "SUCCESS") {
                    var components = component.get('v.components');
                    if(!components) { components = []; }
                    component.set('v.components', cmps);                    
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log(error);
                    }
            }
        );
    },
    /**
     * Since:  01/05/2019
     * Author: Incapsulate
     * Description: below method is used to calculate the column values and put inside the map object
    */
    handleColumnValueSync : function(component,event,nameinput,valueinput,isRecordModified){
        var isReadOnly = false;
        if(event && event.getParam("FormTableDetailObject")){
            isReadOnly = event.getParam("FormTableDetailObject").isReadOnly;
        }
        if(!isRecordModified){
            isReadOnly = false;
        }
        var name = null;
        var value = null;
        if(nameinput){
            name = nameinput;
        }else{
            name = event.getSource().get("v.name");
        }
        if(valueinput){
            value = valueinput;
        }else{
            value = event.getSource().get("v.value") == '' ? 0 : event.getSource().get("v.value");
        }
        var map = component.get("v.sumOfColumnMap");
        var keyarray = name.split("_");
        if(!map){
            map = new Map();
        }
        if(map.get(keyarray[0]) == null){
            var colmap = new Map();
            colmap.set(keyarray[1],parseFloat(value));
            map.set(keyarray[0],colmap);
        }else{
            var colmap = map.get(keyarray[0]);
            if(colmap.get(keyarray[1]) == null){
                colmap = map.get(keyarray[0]);                
                colmap.set(keyarray[1],parseFloat(value));                
            }else{
                if(isReadOnly){
                    event.getSource().set("v.value",colmap.get(keyarray[1]));
                }else{
                	colmap.set(keyarray[1],parseFloat(value));                 
                }
            }
            map.set(keyarray[0],colmap);
        }        
        component.set("v.sumOfColumnMap",map);       
        var mnum = this.calculateSumOfCol(component,map,keyarray[1],event);        
        this.setTheColumnList(component,event,map,mnum,keyarray[1]);   
        this.calculateTotalUsingFormula(component);
    },
    /**
     * Since:  01/05/2019
     * Author: Incapsulate
     * Description: calculate the column values based on coditions
     * Note: code needs enable/disable based on custom metadata, which column needs to be calculated
     * 
    */
    calculateSumOfCol : function(component,map,colname,event){
        var sumofcol = 0;
    	var mykeys = map.keys();
    	for(var mkey of mykeys){
            for(var colkey of map.get(mkey).keys()){
    			if(colkey == colname)
                	sumofcol = sumofcol + parseFloat(map.get(mkey).get(colkey));                
            }            
        }
    	return sumofcol;
	},
    /**
     * Since:  01/05/2019
     * Author: Incapsulate
     * Description: final list which will hold the column or corresponding values.
    */
     setTheColumnList : function(component,event,map,sum,colname){
        var lst = component.get("v.sumMapList");
        if(!lst){
            lst = [];
        }
        var isColNotExist = true;
        for(var listobj of lst){
            if(listobj.key == colname){
                listobj.value = sum;
                isColNotExist = false
                break;
            }
        }        
        if(isColNotExist){
            lst.push({key:colname,value:sum});
        }
        component.set("v.sumMapList",lst);
    },
    /**
     * Since:  01/05/2019
     * Author: Incapsulate
     * Description: Calculate the net amount or value based on formula.
     * Note: As of now the formula is hard coded in code but needs the formal will be
     * fetched from custom metadat.
    */
    calculateTotalUsingFormula : function(component){
        if(component.get('v.formulaColumnName') && component.get('v.formula')){
            var formulaCol = component.get('v.formulaColumnName');
            var formulaColLst = formulaCol.split(",");
            var formula = component.get('v.formula');
            var sum = new Function('formulaex', 'return eval(formulaex)');            
            var lst = component.get("v.sumMapList");
            //below formula need to be setup in the custom metadata
            //or design attribute as required.        
            for(var listobj of lst){
                console.log(listobj.key);
                formula = formula.replace(listobj.key, listobj.value);            
            }
            for(var col of formulaColLst){
                if(formula.includes(col)){
                    formula = formula.replace(col, 0);  
                }
            }
            try{
                var formulaeval = sum(formula);            
                component.set("v.formulaAmount",formulaeval);
            }catch(error){
                console.log(error);           
            }
        }
    }
})