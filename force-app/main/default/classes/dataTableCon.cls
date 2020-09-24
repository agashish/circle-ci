public with sharing class dataTableCon {

    List<Account> accounts;
    public boolean showBlock {get; set;}
    
    public void openPopup() {
        showBlock = true;
    }

    public List<Account> getAccounts() {
        if(accounts == null)
            accounts = [SELECT name, owner.name, Id, Site, (Select Id, LastName from Contacts) FROM account LIMIT 10];
        return accounts;
    }


}