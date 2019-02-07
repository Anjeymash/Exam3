/**
 * Created by Anjeymash on 03.02.2019.
 */
@IsTest
public class TestRestFilmActorService {

    class FilmWrapper {
        String filmName;
        List<Actor__c> actors;
    }

    public static String ActorFilmsSerialize() {
        List<FilmWrapper> wrappers = new List<FilmWrapper>();
        for (Integer i = 0; i < 10; i++) {
            FilmWrapper wrapper = new FilmWrapper();
            wrapper.filmName = 'Film' + i;
            wrapper.actors = new List<Actor__c>{
                    new Actor__c(name = 'Actor' + i),
                    new Actor__c(name = 'Actor' + i * 2),
                    new Actor__c(name = 'Actor' + i * 3)
            };
            wrappers.add(wrapper);
        }
        return JSON.serialize(wrappers);
    }
    @IsTest
    public static void FilmsCreationTest() {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri =
                'https://ap4.salesforce.com/services/apexrest/RESTFilmActorService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(ActorFilmsSerialize());
        RestContext.request = request;
        String result = RESTFilmActorService.addFilmAndActor();
        List<Film__c> films = [
                SELECT name
                FROM Film__c
                WHERE name LIKE 'Film%'
        ];
        List<Actor__c> actors = [
                SELECT name
                FROM Actor__c
                WHERE name LIKE 'Actor%'
        ];
        Test.stopTest();
        System.assertEquals('success', result);
        System.assertEquals(10, films.size());
        System.assertEquals(19, actors.size());
    }

    @IsTest
    public static void ActorsDeleteTest() {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri =
                'https://ap4.salesforce.com/services/apexrest/RESTFilmActorService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(ActorFilmsSerialize());
        RestContext.request = request;
        RESTFilmActorService.addFilmAndActor();
        String result = RESTFilmActorService.deleteActor();
        List<ActorInFilm__c> junctions = [
                SELECT id
                FROM ActorInFilm__c
                WHERE actor__r.name LIKE 'Actor%'
        ];
        Test.stopTest();
        System.assertEquals('success', result);
        System.assertEquals(0, junctions.size());

    }
    @IsTest
    public static void ActorsNonDuplicateTest() {

        Test.startTest();

        RestRequest request = new RestRequest();
        request.requestUri =
                'https://ap4.salesforce.com/services/apexrest/RESTFilmActorService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(ActorFilmsSerialize());
        RestContext.request = request;
        RESTFilmActorService.addFilmAndActor();
        String result = RESTFilmActorService.addFilmAndActor();

        List<Actor__c> actors = [
                SELECT name
                FROM Actor__c
                WHERE name LIKE 'Actor%'
        ] ;
        Test.stopTest();
        System.assertEquals('success', result);
        System.assertEquals(19, actors.size());
    }

    @IsTest
    public static void NullDataTest() {

        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri =
                'https://ap4.salesforce.com/services/apexrest/RESTFilmActorService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = null;
        RestContext.request = request;
        Boolean success = true;
        try {
            String result = RESTFilmActorService.addFilmAndActor();
        } catch (NullPointerException e) {
            success = false;
        }
        Test.stopTest();
        System.assertEquals(false, success);

    }
    @IsTest
    public static void NullNameTest() {
        List<FilmWrapper> wrappers = new List<FilmWrapper>();
        Test.startTest();
        for (Integer i = 0; i < 10; i++) {
            FilmWrapper wrapper = new FilmWrapper();
            wrapper.filmName = 'Film' + i;
            wrapper.actors = new List<Actor__c>{
                    new Actor__c()
            };
            wrappers.add(wrapper);
        }
        RestRequest request = new RestRequest();
        request.requestUri =
                'https://ap4.salesforce.com/services/apexrest/RESTFilmActorService/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(JSON.serialize(wrappers));
        RestContext.request = request;
        String result = RESTFilmActorService.addFilmAndActor();
        Test.stopTest();
        System.assertNotEquals('success', result);
    }

}