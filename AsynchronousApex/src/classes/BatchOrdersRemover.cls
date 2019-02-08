/**
 * Created by mashkovskiya on 12/17/2018.
 */
global class BatchOrdersRemover implements Database.Batchable<sObject> {
    public List<Order__c> orders;
    global BatchOrdersRemover(List<Order__c> orders) {
        this.orders = orders;

    }
    global List<Order__c> start(Database.BatchableContext bc) {
        return orders;
    }
    global void execute(Database.BatchableContext bc, List<Order__c> orders) {
        delete orders;

    }
    global void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
    }
}