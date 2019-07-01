/*
<!--@Author Incapsulate
File upload is used to attached the file and saved in the standard content objects 
-->*/

({
    helperMethod: function () {

    },
    doInit: function (component, event) {
        try {
            let file = component.get("v.file");
            let ret = component.get("v.renditionMap")[file.FileType];
            let pageNum = file.FileType == 'PDF' ? '&page=0' : '';
            // if(ret)
            //     component.set("v.fileType",ret);
            let baseUrl = component.get("v.baseUrl");
            component.set("v.filePreview", baseUrl + '/sfc/servlet.shepherd/version/renditionDownload?rendition=' + ret + '&versionId=' + file.Id + '&operationContext=CHATTER&contentId=' + file.ContentBodyId + pageNum);
        } catch (error) {

        }
    },
    handleDelete: function (component, event) {
        try {
            var ContentDocumentId = component.get("v.file.ContentDocumentId");
            var action = component.get("c.deleteDocument");
            action.setParams({
                "recordId": ContentDocumentId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Success response state: ' + state);
                    this.sortSelectedFiles(component, event);
                } else {
                    console.log('Problem getting findings, response state: ' + state);
                }
            });
            $A.enqueueAction(action);
        } catch (jex) {
            console.error('Error in component- FileTile, jsHelper, method- handleDelete');
            console.error(jex);
        }
    },
    handleDeleteRecord: function (component, event) {
        var toastEvent = $A.get("e.force:showToast");
        component.find("deleteFile").deleteRecord($A.getCallback(function (deleteResult) {
            // NOTE: If you want a specific behavior(an action or UI behavior) when
            // this action is successful
            // // then handle that in a callback (generic logic when record is changed
            // should be handled in recordUpdated event handler)
            var toastEvent = $A.get("e.force:showToast");
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                // record is deleted
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "The file has been updated successfully."
                });
                toastEvent.fire();
                const selectedFiles = component.get("v.selectedFiles");
                const fileId = component.get("v.file.ContentDocumentId");
                const sortedFiles = selectedFiles.filter(file => file.ContentDocumentId != fileId);
                component.set("v.selectedFiles", sortedFiles);
                component.destroy();
            } else if (deleteResult.state === "INCOMPLETE") {
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "warning",
                    "message": "Error in deleting the file."
                });
                toastEvent.fire();
                console.log("User is offline, device doesn't support drafts.");
            } else if (deleteResult.state === "ERROR") {
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": "Error in deleting the file."
                });
                toastEvent.fire();
                console.log('Problem deleting record, error: ' +
                    JSON.stringify(deleteResult.error));
            } else {
                console.log('Unknown problem, state: ' + deleteResult.state + ', error: ' + JSON.stringify(deleteResult.error));
            }
            
        }));
    },
    sortSelectedFiles: function (component, event) {
        try {
            const selectedFiles = component.get("v.selectedFiles");
            const fileId = component.get("v.file.ContentDocumentId");
            const sortedFiles = selectedFiles.filter(file => file.ContentDocumentId != fileId);
            component.set("v.selectedFiles", sortedFiles);
        } catch (jex) {
            console.error('Error in component- FileTile, jsHelper, method- sortSelectedFiles');
            console.error(jex);
        }
    },
    previewRequest: function (component, event) {
        try {
            // let ret = component.get("v.renditionMap")[event.srcElement.getAttribute('data-type')] ;
            // let file = component.get("v.file");
            // component.set("v.versionId", '/sfc/servlet.shepherd/version/renditionDownload?rendition=' + ret + '&versionId=' + event.srcElement.getAttribute('data-contentId'));
            // component.set("v.rendition", event.srcElement.getAttribute('data-type') == "JPG" ? "ORIGINAL_Jpg" : "SVGZ");
            // component.set("v.fileTitle", event.srcElement.getAttribute('data-title'));
            this.doInit(component, event);
            component.set("v.preview", component.get("v.preview") ? false : true);
        } catch (jex) {
            console.error('Error in component- SaveAttachmentComp, jsHelper, method- previewRequest');
            console.error(jex);
        }
    },
})