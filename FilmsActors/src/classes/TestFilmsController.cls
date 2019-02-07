@IsTest
public class TestFilmsController {
    @TestSetup
    public static void setup() {
        List<Actor__c>actors = new List<Actor__c>();
        List<Film__c> films = new List<Film__c>();
        List<ActorInFilm__c > junctions = new List<ActorInFilm__c>();


        for (Integer i = 0; i < 10; i++) {
            Actor__c actor = new Actor__c (name = 'Actor' + i);
            Film__c film = new Film__c(name = 'Film' + i);
            ActorInFilm__c junction = new ActorInFilm__c(film__r = film, actor__r = actor);
            actors.add(actor);
            films.add(film);
            junctions.add(junction);
        }
        insert actors;
        insert films;
        for (ActorInFilm__c junction : junctions) {
            junction.film__c = junction.film__r.id;
            junction.actor__c = junction.actor__r.id;
        }
        insert junctions;
    }
    @IsTest
    public static void TestAllFilms() {
        Test.startTest();
        Map<String, List<String>> mapOfFilmsFilms = FilmsController.getFilms('');
        Test.stopTest();
        System.assertEquals(10, mapOfFilmsFilms.keySet().size());
    }
    @IsTest
    public static void TestCurrentFilm() {
        Test.startTest();
        Map<String, List<String>> mapOfFilmsFilms = FilmsController.getFilms('Actor1');
        Test.stopTest();
        System.assertEquals(1, mapOfFilmsFilms.keySet().size());
        System.assertEquals('Actor1', mapOfFilmsFilms.get('Film1').get(0));
    }
    @IsTest
    public static void TestTwoActorsInFilm() {
        Test.startTest();
        Actor__c actor = new Actor__c (name = 'ActorN');
        insert actor;
        Film__c film = [SELECT id, name FROM Film__c WHERE name = 'Film1'];
        ActorInFilm__c junction = new ActorInFilm__c(
                name = film.name + actor.name,
                film__c = film.id,
                actor__c = actor.id);
        insert junction;
        Map<String, List<String>> mapOfFilmsFilms = FilmsController.getFilms('Actor1');
        Test.stopTest();
        System.assertEquals(1, mapOfFilmsFilms.keySet().size());
        System.assertEquals('ActorN', mapOfFilmsFilms.get('Film1').get(1));
    }

    @IsTest
    public static void TestGetActors() {
        Test.startTest();
        List<String> actorNames = FilmsController.getActors('Actor');
        Test.stopTest();
        System.assertEquals(10, actorNames.size());
    }

}