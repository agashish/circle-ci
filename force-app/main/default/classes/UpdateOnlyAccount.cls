public with sharing class UpdateOnlyAccount {
    
    public UpdateOnlyAccount() {
        System.debug('[Constructor Invoked]');    
    }
    
    public void getAccounts(List<Account> accList) {
        
        System.debug('Accoutn size :: ' + accList.size());
        List<Account> accP = new List<Account>();
        for(Account acc: accList) {
            
            if(acc.Site != '' || acc.Site != null) { 
                acc.description = acc.Name + '-' + acc.Industry;
                acc.Site = acc.description;
                accP.add(acc);
            }
            
        }
        
         // Updation
         System.debug('Accoutn for update with Site text : ' + accP);
         // update accP;
         System.debug('Update Invoked');
    }
    
}