/**
 * Created by mashkovskiya on 1/31/2019.
 */

public class FilmsController {

    class FilmWrapper {
        @AuraEnabled public String filmName;
        @AuraEnabled public List<Actor__c> actors { get; set; }
    }


    @AuraEnabled
    public static List<String> getActors(String searchKey) {
        List<String> actors = new List<String>();
        for (Actor__c actor : [SELECT name FROM Actor__c WHERE name LIKE :searchKey + '%']) {
            actors.add(actor.name);
        }
        return actors;
    }

    @AuraEnabled
    public static List<FilmWrapper> getFilms(String searchKey) {
        Map<String, List<Actor__c>> filmsMap = new Map<String, List<Actor__c>> ();
        Set<String> films = new Set<String>();
        List<ActorInFilm__c> actorAndfilms = [
            SELECT id, actor__r.name, film__r.name, film__c, actor__c
            FROM ActorInFilm__c
            WHERE actor__r.name
                LIKE :searchKey + '%'
            AND film__c != null
        ];

        for (ActorInFilm__c junction : actorAndfilms) {
            films.add(junction.film__r.name);
        }

        for (String filmName : films) {
            for (ActorInFilm__c junction : [
                SELECT id, actor__r.name, film__r.name, film__c, actor__c, actor__r.CountFilms__c, 	actor__r.image__c
                FROM ActorInFilm__c
                WHERE film__r.name
                    IN :films
            ]) {
                if (junction.film__r.name == filmName) {
                    if (filmsMap.containsKey(filmName)) {
                        filmsMap.get(filmName).add(junction.actor__r);
                    } else {
                        List<Actor__c> listActor = new List<Actor__c>();
                        listActor.add(junction.actor__r);
                        filmsMap.put(filmName, listActor);
                    }
                }
            }
        }

        List<FilmWrapper> wrappers = new List<FilmWrapper>();
        for (String film : filmsMap.keySet()) {
            FilmWrapper wrapper = new FilmWrapper();
            wrapper.filmName = film;
            wrapper.actors = filmsMap.get(film);
            wrappers.add(wrapper);
        }
        return wrappers;

    }
}