trigger updateparentChildCase on Account (After update) {

    System.debug('Pick the particular event for execution'); 

    if(Trigger.isAfter && Trigger.isUpdate) {
    
        System.debug(Trigger.new); 
        
        // GRAB IDS TO CHECK HOW MANY RECORDS ARE COMING WITH PARENT ID
        Set<id> prtId = new Set<Id>();
        for(Account getId: Trigger.new) {
        
            if(getId.Is_Allow_to_update_all__c) {
            
                System.debug(getId.ParentId);
                prtId.add(getId.ParentId);
            
            }
        
        }
        
        System.debug('Invoking Just parent only through Current Record Id');  
        Map<Id, Account> parentAccount = new Map<Id, Account>([
            Select 
                Id,
                Name,
                ParentId, 
                Ownership
            From 
                Account
            Where
                Id IN: prtId 
        ]);          
        System.debug('---------' + parentAccount);
        
        // Invoking Current with child accounts
        List<Account> accRecord = [
            Select
                Id, 
                Name,
                Ownership,
                ParentId,
                (
                    Select 
                        Id,
                        Name,
                        ParentId,
                        Ownership
                    From
                        ChildAccounts                        
                )
            From 
                Account
            Where
                Id IN: Trigger.new
            AND
               Is_Allow_to_update_all__c = true                                                                    
        ];
        System.debug('---------' + accRecord);
        
        List<Account> childUpdate = new List<Account>();
        List<Account> parentUpdate = new List<Account>();
        
        for(Account acc: accRecord) {
        
            System.debug('---current record id : ' + acc.Id);
            System.debug('---child record are : ' + acc.ChildAccounts);
            
            // Check Parent record exists
            if(parentAccount.containsKey(acc.ParentId)) {
            
                // If found true
                // Will update with current valu into parent also
                parentAccount.get(acc.Parentid).Ownership = acc.Ownership;
                parentUpdate.add(parentAccount.get(acc.ParentId));
            
            }
            
            // Update the child accounts
            for(Account chAccount: acc.ChildAccounts) {
            
                chAccount.Ownership = acc.Ownership;
                childUpdate.add(chAccount);
            
            }
        
        }
        
        System.debug('---->> ' + parentAccount);
        System.debug('======= ' + childUpdate);
        
        update childUpdate;
        update parentUpdate;
       
    }

}