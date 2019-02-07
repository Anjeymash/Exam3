/**
 * Created by mashkovskiya on 1/31/2019.
 */
({

    searchKey: function (component, event, helper) {
        var myEvent = $A.get("e.c:SearchKeyChange");
        myEvent.setParams({"searchKey": component.find("InputSelectDynamic").get("v.value")});
        myEvent.fire();
    },

    searchKeyChange: function (component, event, helper) {
        var myEvent = $A.get("e.c:SearchKeyChange");
        myEvent.setParams({"searchKey": event.target.value});
            myEvent.fire();
        helper.getactors(component, event);
    }
})