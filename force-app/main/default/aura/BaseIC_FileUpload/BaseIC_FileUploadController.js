({  
    doInit : function( component, event, helper ) {
       
        helper.getBaseURL(component, event).then( $A.getCallback( function( response ) {              
            component.set("v.baseUrl",response.baseURL);
            let renditions = {
                "JPG": "ORIGINAL_Jpg",
                "PNG": "ORIGINAL_Png",
                "PDF": "SVGZ"
            };
            component.set("v.renditionMap",renditions);
        })).catch(function(error){
            console.error( error);
        });

        if(component.get("v.refresh")){
            component.set("v.refresh",false);
            helper.getLoaded(component, event);           
        }            
    },
    onTabRefreshed : function(component, event){
        //event.stopPropogation();
    },
    handleUploadFinished : function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            'type' : 'success',
            "message": "The files has been uploaded successfully."
        });
        toastEvent.fire();
        /**
         * Added By: Rajkiran
         * Additional field detail update after insert of the documents
         * Start Here 
         */
       if((component.get('v.typeValue') && component.get('v.typeValue') != "") || 
          (component.get('v.descriptionValue') && component.get('v.descriptionValue') !="")){
                var uploadedFile = event.getParam("files")[0];
                var documentId = uploadedFile.documentId;
                var action = component.get('c.saveDocumentAdditionalDetail');
                var fd = {};
                //fd.fileTitle =  component.get('v.titleValue');
                fd.fileType =  component.get('v.typeValue');
                fd.fileDescription =  component.get('v.descriptionValue');
                
                action.setParams({
                    'recordId': documentId,
                    'jsonString': JSON.stringify(fd)
                });
                action.setCallback(this, function(response) {
                        if(response.getState() === 'SUCCESS') {
                            helper.getLoaded(component, event);
                        }else {
                            console.log('Something went wrong while updating the file details');
                            //fetch the existing detail whatever inserted
                            helper.getLoaded(component, event);
                        }
                });
                $A.enqueueAction(action);
       }else{
           helper.getLoaded(component, event);
       }
        /**
         * Additional field detail update after insert of the documents
         * End Here 
         */
    },
    handleWorkorderChanged : function(component, event, helper){
        helper.getLoaded(component, event);
    },
    handleFileClick : function( component, event, helper ) {
        var clickedFileId = event.srcElement.getAttribute( 'data-fileId' );
        $A.get( 'e.lightning:openFiles' ).fire({
            recordIds : component.get( 'v.selectedFiles' ).map( function( file ) { return file.ContentDocumentId; } ),
            selectedRecordId : clickedFileId
        });
    },
    handleViewAll : function( component, event, helper ) {
        try {
            component.set("v.viewAll",true);
        } catch (error) {
            
        }
    }
})