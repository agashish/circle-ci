public with sharing class CustomAccount {

    public string accName {get; set;}
    public List<Account> account;

    public string customId {get; set;}
    public string recordName {get; set;}
    public string val{get; set;}

    public CustomAccount(ApexPages.StandardController controller) {
        val = 'Hello Ji';
    }
    
    public pagereference updateAccount() { 
        System.debug('customId ---- ' + ApexPages.currentPage().getParameters().get('customId'));
        System.debug('recordName ---- ' + ApexPages.currentPage().getParameters().get('recordName'));
        
        customId = ApexPages.currentPage().getParameters().get('customId');
        recordName = ApexPages.currentPage().getParameters().get('recordName');
        
        Account acc = new Account();
        acc.id = customId;
        acc.Name = recordName;
        
        update acc;
        System.debug('acc : ' + acc);
        
        return null;
    }
    
    public void saveAccount() {
        Account acc = new Account();
        acc.Name = 'VF200';
        
        insert acc;
    }
    
    
    
    public void updateProgress() {

        Account acc = new Account();
        acc.Id = customId;
        acc.Name = recordName;
        
        System.debug(acc);
        update acc;          
    
    }

    public List<Account> getPrintAccounts() {
    
        account = [Select Id, Name, (Select Id, LastName from Contacts order by Id desc) from Account Limit 10 ];
        return account;
    }
    
}