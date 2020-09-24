public class CallByProcessBuilder {
	
    @InvocableMethod
    public static void updateChildByParentId(List<Account> acc) {
    	System.debug('Account :: ' + acc);
        Set<Id> accIds = new Set<Id>();
        for(Account account : acc) {
			System.debug('account.Id :' + account.Id);
            accIds.add(account.Id);
        }
        System.debug('accIds :' + accIds);
        
        // #### GET ALL CHILD ACCOUNTS TO UPDATE THE RECORDS
        List<Account> childAccounts = [SELECT Id, Name, Industry, Rating, Website, ParentId from Account WHERE ParentId IN: accIds];
        System.debug('childAccounts :' + childAccounts);
        
        // #### START UPDATING THE INDUSTRY PICKLIST FIELD VALUE
        List<Account> upAccount = new List<Account>();
        for(Account chAccount : childAccounts) {
            if(chAccount.Industry == 'Electronics' || chAccount.Industry == 'Banking') {
                chAccount.Website = 'www.facebook.com';
                upAccount.add(chAccount);
            }
        }
        
        // #### NOW CHARGE TO UPDATE THE CHILD ACCOUNT RECORDS
        System.debug('upAccount :' + upAccount);
        update(upAccount);
    }
}