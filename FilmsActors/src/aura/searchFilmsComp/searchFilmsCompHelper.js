/**
 * Created by mashkovskiya on 2/6/2019.
 */
({

    getactors: function (component, event) {
        var searchKey = event.target.value;
        var action = component.get("c.getActors");
        action.setParams({
            "searchKey": searchKey
        });
        action.setCallback(this, function (a) {
            var actors = a.getReturnValue();
            component.set("v.actors", actors);
            console.log(actors);
        });
        $A.enqueueAction(action);
    }
})