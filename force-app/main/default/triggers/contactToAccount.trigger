trigger contactToAccount on Contact (after insert) {

    if(Trigger.isAfter && RecursiveClass.flag) {
    
        // SETUP TO STOP TO INVOKE AGAIN AND PREVENT TO MAKE RECURSIVE
        RecursiveClass.flag = false;
        
        System.debug('Trigger.isAfter');
        System.debug('RecursiveClass.flag : ' + RecursiveClass.flag);
        
        List<Account> accounts = new List<Account>();
        
        for(Contact con: Trigger.new) {
            Account acc = new Account();
            acc.Name = con.LastName;
            acc.phone = con.Phone;
            
            accounts.add(acc);
        }
        
        insert accounts;
    
    }

}