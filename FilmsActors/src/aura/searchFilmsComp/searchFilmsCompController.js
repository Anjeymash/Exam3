/**
 * Created by mashkovskiya on 1/31/2019.
 */
({
    doInit: function (component) {
        var actionActors = component.get("c.getActors");
        actionActors.setParams({
            "searchKey": ""
        });
        actionActors.setCallback(this, function (a) {
            var actors = a.getReturnValue();
            component.set("v.actors", actors);
            console.log(actors);
        });
        $A.enqueueAction(actionActors);
    },

    searchKey: function (component, event, helper) {
        component.set("v.boolean", true);
        var myEvent = component.getEvent("SearchKeyChange");
        myEvent.setParams({"searchKey": component.find("InputSelectDynamic").get("v.value")});
        myEvent.fire();
    },

    searchKeyChange: function (component, event, helper) {
        component.set("v.boolean", true);
        var myEvent = component.getEvent("SearchKeyChange");
        myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();
        helper.getactors(component, event);
    }
})