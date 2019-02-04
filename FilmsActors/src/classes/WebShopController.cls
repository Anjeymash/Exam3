/**
 * Created by mashkovskiya on 1/24/2019.
 */

public class WebShopController {

    public WebShopController(ApexPages.StandardController controller) {

        List<String> fields = new List<String>();
        fields.addAll(Schema.getGlobalDescribe().get('Product_Table__c').getDescribe().fields.getMap().keySet());
        controller.addFields(fields);
        item = (Product_Table__c) controller.getRecord();
    }

    public Product_Table__c item { get; set; }
    public String contactEmail { get; set; }
    public Integer unitsCount { get; set; }
    public Contact contact { get; set; }


    public void getContactByEmail() {
        contact = new Contact();
        List<Contact> contacts = [
            SELECT id, firstname, lastname, email
            FROM Contact
            WHERE email
                LIKE :contactEmail
            AND email != ''
        ];
        if (!contacts.isEmpty()) {
            contact = contacts.get(0);
        } else {
            contact.email = contactEmail;
        }
        contactEmail = contact.email;

    }
    public void makeOrder() {
        ApexPages.Message myMsg;
        try {
            if (unitsCount <= 0) {
                throw new DmlException('quantity should be more than 0');
            }
            upsert contact;
            item.Units_Available__c -= unitsCount;
            Order_Table__c order = new Order_Table__c(
                Name = item.name,
                Contact__c = contact.id,
                Product__c = item.id,
                Units__c = unitsCount,
                Order_Amount__c = item.unit_Price__c * unitsCount
            );
            update item;
            insert order;
            myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Order made:' + order.name + ' ' + unitsCount);
        } catch (DmlException e) {
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
        } finally {
            ApexPages.addMessage(myMsg);
        }
    }
}