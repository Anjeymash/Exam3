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
    }
})