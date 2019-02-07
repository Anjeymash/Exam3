/**
 * Created by mashkovskiya on 1/30/2019.
 *   [{"filmName":"Darkness","actors":[{"name":"Bradolf Pittler"},{"name":"AAA"}]}]
    /services/apexrest/RESTFilmActorService*/


@RestResource(urlMapping='/RESTFilmActorService')
global class RESTFilmActorService {
    private static Map<String, Film__c> filmsMap ;
    private static List<ActorInFilm__c> junctionObjectsList ;
    private static Map<String, Actor__c> actorsMap ;

    class FilmWrapper {
        String filmName;
        List<Actor__c> actors;
    }

    private static void initialize() {
        RestRequest request = RestContext.request;
        List<Object> objects = (List<Object>) JSON.deserializeUntyped(request.requestbody.tostring());
        filmsMap = new Map<String, Film__c>();
        junctionObjectsList = new List<ActorInFilm__c>();
        actorsMap = new Map<String, Actor__c>() ;

        for (Object obj : objects) {
            String item = JSON.serialize(obj);
            FilmWrapper fWrapper = (FilmWrapper) JSON.deserialize(item, FilmWrapper.class);
            if (!filmsMap.containsKey(fWrapper.filmName)) {
                Film__c film = new Film__c(name = fWrapper.filmName);
                filmsMap.put(fWrapper.filmName, film);
                for (Actor__c actor : fWrapper.actors) {
                    junctionObjectsList.add(new ActorInFilm__c(name = film.name + actor.name, film__r = film, actor__r = actor));
                    if (!actorsMap.containsKey(actor.name)) {
                        actorsMap.put(actor.name, actor);
                    }
                }
            }
        }
    }

    @HttpPost
    global static String addFilmAndActor() {
        String result;
        List<Film__c> filmsIns = new List<Film__c>();
        List<Actor__c> actorsIns = new List<Actor__c>();
        List<ActorInFilm__c> junctionToInsert = new List<ActorInFilm__c>();
        Map<String, ActorInFilm__c> juncMap = new Map<String, ActorInFilm__c>();
        initialize();
        for (Actor__c actor : [SELECT id, name FROM Actor__c]) {
            if (actorsMap.containsKey(actor.name)) {
                actorsMap.put(actor.name, actor);
            }
        }
        for (Film__c film : [SELECT id, name FROM Film__c]) {
            if (filmsMap.containsKey(film.name)) {
                filmsMap.put(film.name, film);
            }
        }
        actorsIns.addall(actorsMap.values());
        filmsIns.addall(filmsMap.values());

        for (ActorInFilm__c junction : junctionObjectsList) {
            if (junction.film__r.id == null) {
                junction.film__r = filmsMap.get(junction.Film__r.name);
            }
            if (junction.actor__r.id == null) {
                junction.actor__r = actorsMap.get(junction.actor__r.name);
            }
            junction.film__c = junction.film__r.id;
            junction.actor__c = junction.actor__r.id;
            juncMap.put(junction.Name, junction);
        }

        for (ActorInFilm__c jun : [SELECT name FROM ActorInFilm__c]) {
            if (juncMap.containsKey(jun.name)) {
                juncMap.remove(jun.name);
            }
        }
        junctionToInsert.addAll(juncMap.values());
        try {
            upsert filmsIns;
            upsert actorsIns;
            insert junctionToInsert;
            result = 'success';
        } catch (DmlException e) {
            result = e.getMessage();
        }
        return result;
    }

    @HttpDelete
    global static String deleteActor() {
        String result;
        initialize();
        List<ActorInFilm__c> junctionsToDelete = new List<ActorInFilm__c>();
        for (ActorInFilm__c junction : [
            SELECT id, film__c, actor__c, film__r.name, actor__r.name
            FROM ActorInFilm__c
            WHERE film__r.name IN :filmsMap.keySet()
        ]) {
            if ((filmsMap.containsKey(junction.film__r.name)) && (actorsMap.containsKey(junction.actor__r.name))) {
                junctionsToDelete.add(junction);
            }
        }
        try {
            delete junctionsToDelete;
            result = 'success';
        } catch (DmlException e) {
            result = e.getMessage();
        }
        return result;
    }
}