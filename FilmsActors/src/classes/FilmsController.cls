/**
 * Created by mashkovskiya on 1/31/2019.
 */

public class FilmsController {

    @AuraEnabled
    public static List<String> getActors(String searchKey) {
        List<String> actors = new List<String>();
        for (Actor__c actor : [SELECT name FROM Actor__c WHERE name LIKE :searchKey + '%']) {
            actors.add(actor.name);
        }
        return actors;
    }

    @AuraEnabled
    public static Map<String, List<String>> getFilms(String searchKey) {
        Map<String, List<String>> filmsMap = new Map<String, List<String>> ();
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
                SELECT id, actor__r.name, film__r.name, film__c, actor__c
                FROM ActorInFilm__c
                WHERE film__r.name
                    IN :films
            ]) {
                if (junction.film__r.name == filmName) {
                    if (filmsMap.containsKey(filmName)) {
                        filmsMap.get(filmName).add(junction.actor__r.name);
                    } else {
                        List<String> listActor = new List<String>();
                        listActor.add(junction.actor__r.name);
                        filmsMap.put(filmName, listActor);
                    }
                }
            }
        }
        return filmsMap;
    }
}