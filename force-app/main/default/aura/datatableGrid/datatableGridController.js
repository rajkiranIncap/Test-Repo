({
    /*
     * This finction defined column header
     * and calls getAccounts helper method for column data
     * editable:'true' will make the column editable
     * */
doInit : function(component, event, helper) {        
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', editable:'true', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', editable:'true', type: 'phone'},
            {label: 'Rating', fieldName: 'Rating', editable:'true', type: 'text'},
            {label: 'Custom Field', fieldName: 'My_Custom_Field__c', editable:'true', type: 'text'}
        ]);        
        helper.getAccountLists(component, helper);
    },

    /*
     * This function is calling saveDataTable helper function
     * to save modified records
     * */
    onSave : function (component, event, helper) {
        helper.saveDataTable(component, event, helper);
    }
})