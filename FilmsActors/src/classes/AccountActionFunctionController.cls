/**
 * Created by Anjeymash on 23.12.2018.
 */
public with sharing class AccountActionFunctionController {
    public AccountActionFunctionController() {
        ac = new Account();
        document = new Attachment();
        inputIsVisible = true;
        titleIsVisible = true;
    }
    public ID acid { get; set; }
    public String docName { get; set; }
    public Account ac { get; set; }
    public String sysTime { get; set; }
    public String userTime { get; set; }
    public Boolean inputIsVisible { get; set; }
    public Boolean titleIsVisible { get; set; }
    public Attachment document { get; set; }

    public void createAccount() {
    }
    public void save() {
        try {
            insert ac;
            acid = ac.id;
            inputIsVisible = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'account saved successfully'));
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error saving account'));
        }
    }
    public PageReference createWithDate() {
        inputIsVisible = false;
        Datetime myDT = Datetime.now();
        sysTime = myDT.format('MM/dd/yyyy HH:mm:ss a z');
        Integer offset = UserInfo.getTimezone().getOffset(myDT);
        Datetime local = myDT.addSeconds(offset / 1000);
        userTime = local.format('dd:MMM:yy HH:mm:ss a z');
        return null;
    }
    public PageReference upload() {
        docName = document.name;
        titleIsVisible = false;
        Account acct = [
            SELECT id, name
            FROM Account
            WHERE name = :ac.name
            LIMIT 1
        ];
        document.parentId = acct.id;

        try {
            insert document;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'File uploaded successfully'));
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading file'));
            return null;
        } finally {
            document.body = null;
            document = new Attachment();
        }
        return null;
    }
}