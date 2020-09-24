global class UpdateContactAddInfo implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
         return Database.getQueryLocator(
           'SELECT ID, Name, ' +
            '(SELECT ID, Name, AccountId, Amount_x__c, AssistantName, Title ' +
            ' FROM Contacts) FROM Account ' +
             ' where id IN (select accountId from contact where accountId != null) '
         );
    }
    
    global void execute(Database.BatchableContext bc, List<Account> acc) {
        List<Contact> contact = new List<Contact>();
        for(Account account: acc) { 
            //if(account.contacts.size() > 0) {
             	for(Contact c: account.contacts) {
                    if( c.AssistantName == null ) {
                    	c.AssistantName = 'Ashish Kr.';
                        c.Title = 'MYTUTORIAL';                        
                    	contact.add(c); 	   
                    }                    
                }   
            //}        
        }
        update contact;
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Its completed');
    }
    
}