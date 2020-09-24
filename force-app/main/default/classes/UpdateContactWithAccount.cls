public class UpdateContactWithAccount extends UpdateContactAssets {

    public UpdateContactWithAccount() {
        
        System.debug('[Constructor Invoked]'); 
        
    } 
    
    public Set<Id> getIdByParent(List<Contact> triggerNew) {
        
        Set<Id> setId = new Set<Id>();
        System.debug('TriggerNew : ' + triggerNew);
        
        for(Contact con: triggerNew) {
            
            System.debug('TriggerValues : ' + con);
            setId.add(con.AccountId);
            
        }
        
	return setId;        
    }
    
    public List<Account> returnAccountWithContactsRecords(Set<Id> accountIds) {
        
        return [
            SELECT 
            	Id,
            	Name,
            	Rollup_Amount_x__c,
                Rollup_Amount_y__c,
            	Rollup_Amount__c,
            	(
                	SELECT 
                    	Id,
                    	Name,
                    	AccountId,
                    	Amount_x__c,
                    	Amount_y__c,
                    	type__c
                    FROM
                    	Contacts
                )
            FROM 
            	Account
            WHERE
            	Id IN: accountIds
        ];
        
    }
    public void init_After(List<sObject> triggerNew) {
    	System.debug('After sum ----- ' + UpdateContactWithAccount.returnSum(10, 20));
    }
    
    public void init(List<sObject> triggerNew) {
        
        System.debug('-----INVOKED-----');
        System.debug(triggerNew);
        
        System.debug('Get Account Unique Ids');
        Set<Id> accountIds = new Set<Id>(this.getIdByParent(triggerNew));
        System.debug(accountIds);
        
        // MAKE A LIST OF ACCOUNT TO UPDATE THE AMOUNT FEILD
        List<Account> updateAccount = new List<Account>();
        
        // MAKE A QUERY TO RETURN ACCOUNT AND CHILD CONTACTS WITH IN SINGLE QUERY
        List<Account> accountRecordWithContacts = this.returnAccountWithContactsRecords(accountIds);
        
        System.debug(accountRecordWithContacts);
        
        for(Account record: accountRecordWithContacts) {
        
        	if( UpdateContactWithAccount.isAllowToMAkeSum(record) ) {
                
                System.debug('-------------' + record.Contacts);
                
                // ADD RECORDS
               	UpdateContactWithAccount.getSumOfPositiveAmount(record.Contacts, record);
                
            } else {
            
                System.debug('No Contact child records are found.');
            
            }            
        }
    }
    
    static public boolean isAllowToMAkeSum(Account record) {
        
        if(record.Contacts.size() > 0) return UpdateContactAssets.returnTrue;
        
	return UpdateContactAssets.returnFalse;      
    }
    
    static public void getSumOfPositiveAmount(List<Contact> recordContacts, Account account) {
        
        Double sumFeild = 0;
        
        System.debug('>>>>>>>>>>>>>>>' + account);
        
        // MAKE A LIST OF ACCOUNT TO UPDATE THE AMOUNT FEILD
        List<Account> updateAccount = new List<Account>();
        account.Rollup_Amount_x__c = 0;
        account.Rollup_Amount_y__c = 0;
        
        for(Contact con: recordContacts) {
            
            // Must use @META DETA FOR STATIC VALUES
            if(con.Amount_x__c != null && con.type__c == 'Positive') {
                account.Rollup_Amount_x__c = UpdateContactWithAccount.returnSum( con.Amount_x__c, account.Rollup_Amount_x__c);
                System.debug('account.Rollup_Amount_x__c :: ' + account.Rollup_Amount_x__c);
            } 
            
            if(con.Amount_y__c != null && con.type__c == 'Negative') {
                account.Rollup_Amount_y__c = UpdateContactWithAccount.returnSum( con.Amount_y__c, account.Rollup_Amount_y__c);
                System.debug('account.Rollup_Amount_y__c :: ' + account.Rollup_Amount_y__c);
            }
            
            // according to record
            account.Rollup_Amount__c = UpdateContactWithAccount.returnSum( account.Rollup_Amount_x__c , account.Rollup_Amount_y__c);
                        
        } 
        
        // Add the record for updation
        updateAccount.add(account);
            
        // Now Going to update
      	update updateAccount;
       	System.debug('Update Account with sum of feilds');
        System.debug(updateAccount);
        
    }
    
    static private Decimal returnSum(Decimal incomingValue, Decimal prevValue) {        
        return incomingValue + prevValue;        
    }   
}