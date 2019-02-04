/**
 * Created by mashkovskiya on 1/28/2019.
 */

@IsTest
public class WebShopControllerTEST {
    public static final Org_Configuration__c orgConf = new Org_Configuration__c(Period_Term__c = 10);
    @TestSetup
    public static void setup() {
        insert orgConf;
        List<Product_Table__c> prodacts = new List<Product_Table__c>();
        for (Integer i = 1; i < 6; i++) {
            prodacts.add(new Product_Table__c(
                name = 'TestProdName' + i,
                title__c = 'TestProdTitle' + i,
                Product_Description__c = 'TestProdDescription' + i,
                unit_Price__c = i,
                Units_Available__c = i + 10,
                Image_Url__c = 'TestProdUrl' + i
            ));
        }
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 1; i < 3; i++) {
            contacts.add(new Contact(lastname = 'TestContName' + i, email = 'TestContName' + i + '@tut.by'));
        }
        insert contacts;
        insert prodacts;
    }

    /*@IsTest
    public static void getProductsTest() {

        Test.startTest();
        WebShopController controller = new WebShopController();
        List<Product_Table__c> prods = controller.products;

        System.assertEquals(5, prods.size());
        Test.stopTest();
    }
*/
   /* @IsTest
    public static void getProductTest() {
        Test.startTest();
        Product_Table__c product = [
            SELECT id, Image_Url__c, Product_Description__c, name, unit_Price__c, Warehouse__c, Units_Available__c, title__c
            FROM Product_Table__c
            WHERE name = 'TestProdName1'
        ];

        WebShopController controller = new WebShopController();
        controller.itemId = product.id;
        Test.stopTest();
        System.assertEquals(product.id, controller.item.id);
    }*/


    @IsTest
    public static void makeOrderTest() {
        Test.startTest();
        Product_Table__c product = [
            SELECT id, Image_Url__c, Product_Description__c, name, unit_Price__c, Warehouse__c, Units_Available__c, title__c
            FROM Product_Table__c
            WHERE name = 'TestProdName1'
        ];
        Contact contact = [
            SELECT id, firstname, lastname, email
            FROM Contact
            WHERE NAME = 'TestContName1'
        ];

        WebShopController controller = new WebShopController();
        controller.item = product;
        controller.contact = contact;
        controller.unitsCount = 1;
        controller.makeOrder();
        Order_Table__c order = [SELECT id, Units__c FROM Order_Table__c WHERE Contact__c = :contact.id];
        Test.stopTest();
        System.assertNotEquals(null, order);
        System.assertEquals(1, order.Units__c);
    }

 /*   @IsTest
    public static void getProductAfterRedirect() {
        Test.startTest();
        Product_Table__c product = [
            SELECT id, Image_Url__c, Product_Description__c, name, unit_Price__c, Warehouse__c, Units_Available__c, title__c
            FROM Product_Table__c
            WHERE name = 'TestProdName1'
        ];
        WebShopController controller = new WebShopController();
        controller.item = product;
        PageReference pr = controller.reDirectToOrder();
        Test.stopTest();
        System.assertEquals(product.id, controller.item.id);
        System.assertEquals(product.id, pr.getParameters().get('itemId'));
    }*/

   /* @IsTest
    public static void redirectHomeTest() {
        Test.startTest();
        WebShopController controller = new WebShopController();
        PageReference pr = controller.backHome();
        System.assertEquals('/apex/WebShopPage', pr.getUrl());
    }*/
    /*@IsTest
    public static void nullContactTest() {
        Test.startTest();
        Product_Table__c product = [
            SELECT id, Image_Url__c, Product_Description__c, name, unit_Price__c, Warehouse__c, Units_Available__c, title__c
            FROM Product_Table__c
            WHERE name = 'TestProdName1'
        ];
        Contact contact = new Contact(email = 'eee');
        WebShopController controller = new WebShopController();
        controller.item = product;
        controller.unitsCount = 1;
        controller.makeOrder();
        Test.stopTest();
        System.assertEquals(null, contact.id);
    }
*/
   /* @IsTest
    public static void nullParamTest() {
        Test.startTest();
        WebShopController controller = new WebShopController();
        PageReference pr = controller.backHome();
        Test.stopTest();
        System.assertEquals(false, pr.getParameters().containsKey('itemId'));
    }*/
}