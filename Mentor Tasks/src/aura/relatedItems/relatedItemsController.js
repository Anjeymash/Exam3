/**
 * Created by mashkovskiya on 3/22/2019.
 */
({
    init: function (cmp, event, helper) {
        helper.getInitParams(cmp);
        helper.fetchData(cmp);
        helper.getMaxPageNumber(cmp);
    },

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam("action");
        cmp.set("v.itemId", event.getParam("row").Id);
        switch (action.name) {
            case "edit":
                helper.editItem(cmp, event);
                break;
            case "delete":
                helper.handleShowModalFooter(cmp);
                break;
        }
    },


    handleNewItem: function (cmp, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "ExternalItem__c",
            "defaultFieldValues": {
                "ParentId__c": cmp.get("v.recordId")
            }
        });
        createRecordEvent.fire();

    },

    callback_DeleteFunction: function (cmp, event, helper) {
        cmp.find("overlayLib").notifyClose();
        cmp.get("v.overlay").close();
        helper.deleteItem(cmp);
    },

    renderPage: function (component, event, helper) {
        helper.fetchData(component);
    },

    handleSort: function (component, event, helper) {
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", event.getParam("fieldName"));
        component.set("v.sortedDirection", event.getParam("sortDirection"));
        console.log(event.getParam("sortDirection"));
        helper.fetchData(component);
    },
    showSpinner: function (component) {
        component.set("v.Spinner", true);
    }
    ,
    hideSpinner: function (component) {
        component.set("v.Spinner", false);
    }

})