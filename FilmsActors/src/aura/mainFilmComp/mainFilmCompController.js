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
            var map = a.getReturnValue();
            var films = [];
            console.log(map);
            for(var key in map){
                films.push({value:map[key], key:key});
            }
            component.set("v.films", films);
            console.log(films);
        });
        $A.enqueueAction(action);
    },
    searchKeyChange: function (component, event, helper) {
        helper.searchKeyChange(component, event);
    },

    showSpinner: function (component) {
        component.set("v.Spinner", true);
    },

    hideSpinner: function (component) {
        component.set("v.Spinner", false);
    }
})