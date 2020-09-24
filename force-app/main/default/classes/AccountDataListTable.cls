public with sharing class AccountDataListTable {

    List<Account> accounts;
    
    public List<Account> getComingAccounts() {
       
       if(accounts == null){
           accounts = [Select Id, Name, site, (Select Id, LastName from Contacts) from Account Limit 10]; 
           System.debug('accounts :: ' + accounts );
        }   
       return accounts; 
       
    }

}