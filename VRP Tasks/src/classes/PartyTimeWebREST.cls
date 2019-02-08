/**
 * Created by mashkovskiya on 12/18/2018.
 */
@RestResource(urlMapping='/PartyTimeWebREST')
global class PartyTimeWebREST {


    @HttpGet
    global static List<Guest__c>getAllGuests() {
        return [SELECT id, name, is_invited__c, contact__c FROM Guest__c];
    }
    @HttpPut
    global static List<Guest__c> addGuests() {

        RestRequest request = RestContext.request;
        List<Guest__c> result = new List<Guest__c>();

        Set<String> names = new Set<String>();
        Set<Guest__c> guests = new Set<Guest__c>();
        List<Object>objs = (List<Object>) JSON.deserializeUntyped(request.requestbody.tostring());
        for (Object obj : objs) {
            String item = JSON.serialize(obj);
            Guest__c guest = (Guest__c) JSON.deserialize(item, Guest__c.class);
            guests.add(guest);
            names.add(guest.name);
        }
        List<Guest__c> existingGuests = [
            SELECT id, name, is_invited__c, contact__c
            FROM Guest__c
            WHERE name = :names
        ];

        for (Guest__c g : guests) {
            Boolean exist = false;
            for (Guest__c gst : existingGuests) {
                if (g.name == gst.name) {
                    exist = true;
                }
            }
            if (exist == false) {
                result.add(g);
            }
        }

        insert result;
        system.debug(result);

        return result;


    }
    /*  @HttpPut
      global static String addGuest() {
          String nameParam = RestContext.request.params.get('name');
          Guest__c guest;
          if (nameParam != null) {

              List<Guest__c> allGuests = [
                  SELECT id, name, is_invited__c, contact__c
                  FROM Guest__c
                  WHERE name = :nameParam
              ];
              if (allGuests.isempty()) {
                  guest = new Guest__c(name = nameParam, is_invited__c = 'yes');
              }
              if (guest != null) {
                  insert guest;
                  return guest.name + 'is inserted';
              }
          }
          return 'guest' + nameParam + '  already invited';
      }*/


}