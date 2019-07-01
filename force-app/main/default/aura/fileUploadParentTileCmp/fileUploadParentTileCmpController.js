/*
<!--@Author Incapsulate
File upload is used to attached the file and saved in the standard content objects 
-->*/
({
    doInit: function (component, event, helper) {
        try {
            helper.doInit(component, event);
        } catch (error) {

        }
    },
    handleRecordUpdated: function (component, event, helper) {
        var eventParams = event.getParams();
        if (eventParams.changeType === "CHANGED") {
            // record is changed
        } else if (eventParams.changeType === "LOADED") {
            // record is loaded in the cache
        } else if (eventParams.changeType === "REMOVED") {
            // record is deleted, show a toast UI message   
        } else if (eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    handleFileClick: function (component, event, helper) {
        var clickedFileId = event.srcElement.getAttribute('data-fileId');
        $A.get('e.lightning:openFiles').fire({
            recordIds: component.get('v.selectedFiles').map(function (file) {
                return file.ContentDocumentId;
            }),
            selectedRecordId: component.get("v.file.ContentDocumentId")
        });
    },
    onTabRefreshed: function (component, event) {
        //event.stopPropogation();
    },
    handleDelete: function (component, event, helper) {
        try {
            var res = confirm("Do you want to delete Attachment ?");
            if (res == true) {
                helper.handleDeleteRecord(component, event);
            }
        } catch (jex) {
            console.error('Error in component- FileTile, jscontroller, method- handleDelete');
            console.error(jex);
        }
    },
    previewRequest: function (component, event, helper) {
        try {
            helper.previewRequest(component, event);
        } catch (jex) {
            console.error('Error in component- FileTile, jscontroller, method- doInIt');
            console.error(jex);
        }
    },
    colseModal: function (component, event, helper) {
        try {
            component.set("v.preview", false);
            component.set("v.previewError", false);
        } catch (jex) {
            console.error('Error in component- FileTile, jscontroller, method- colseModal');
            console.error(jex);
        }
    },
    handleOnLoad: function (component, event, helper) {
        try {
            component.set("v.previewDone", true);
        } catch (jex) {
            console.error('Error in component- FileTile, jscontroller, method- handleOnLoad');
            console.error(jex);
        }
    },
    handleOnError: function (component, event, helper) {
        try {
            component.set("v.previewError", true);
        } catch (jex) {
            console.error('Error in component- FileTile, jscontroller, method- handleOnError');
            console.error(jex);
        }
    },
    handleThumbLoad: function (component, event, helper) {
        try {
            component.set("v.thumbLoaded", true);
        } catch (jex) {
            console.error('Error in component- FileTile, jscontroller, method- handleThumbLoad');
            console.error(jex);
        }
    },
    handleThumbError: function (component, event, helper) {
        try {
            component.set("v.thumbError", true);
        } catch (jex) {
            console.error('Error in component- FileTile, jscontroller, method- handleOnError');
            console.error(jex);
        }
    }
})