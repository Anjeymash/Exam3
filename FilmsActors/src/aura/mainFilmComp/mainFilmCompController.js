/**
 * Created by mashkovskiya on 1/31/2019.
 */
({
    doInit: function (component) {
        var action = component.get("c.getFilms");
        action.setParams({
            "searchKey": ""
        });
        action.setCallback(this, function (a) {
            var films = a.getReturnValue();
            var childComponent = component.find("results");
            childComponent.set("v.films", films);
            console.log(films);
        });
        $A.enqueueAction(action);
    },
    searchKeyChange: function (component, event, helper) {
        helper.searchKeyChange(component, event);
    }
    ,
    showSpinner: function (component) {
        component.set("v.Spinner", true);
    }
    ,
    hideSpinner: function (component) {
        component.set("v.Spinner", false);
    }
})