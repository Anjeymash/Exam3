/**
 * Created by mashkovskiya on 1/31/2019.
 */

({
    searchKeyChange: function (component, event) {

        var searchKey = event.getParam("searchKey");
        var action = component.get("c.getFilms");
        action.setParams({
            "searchKey": searchKey
        });
        action.setCallback(this, function (a) {
            var films = a.getReturnValue();
            var childComponent = component.find("results");
            childComponent.set("v.films", films);

        });
        $A.enqueueAction(action);
    }
})