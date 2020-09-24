@RestResource(urlMapping='/Accounts/*')
global with sharing class RestAccount {
	
    @HttpGet
    global static String getObjectResults() {
        List<Account> accounts = new List<Account>();
        accounts = [Select Id, Name, (Select Id, Name from Contacts) FROM Account LIMIT 10];        
        
        List<Contact> contacts = new List<Contact>();
        contacts = [Select Id, Name FROM Contact LIMIT 10];
        
        String jsonStr = JSON.serialize(new AccountResultWrapper(accounts, contacts));
        return jsonStr;
    }
    
    public class AccountResultWrapper {
        @AuraEnabled
        public List<Account> accounts;
        
        @AuraEnabled
        public List<Contact> contacts;
        
        public AccountResultWrapper(List<Account> accounts, List<Contact> contacts) {
            this.accounts = accounts;
            this.contacts = contacts;
        }
    }
    
    @HttpPost
    global static Id addAccount(String accName){
        Account newAccount = new Account(Name=accName);
        insert newAccount;
        return newAccount.Id;
    }
    
    @HttpDelete
    global static void accountDelete() {
        RestRequest request = RestContext.request;
        String accountId = request.requestUri.subString(request.requestUri.lastIndexOf('/') + 1);
        Account acc = [Select Id from Account where Id =: accountId];
        delete acc;
    }
    
    /*@HttpPut
    global static Id updateAccount() {
        
    }*/
}