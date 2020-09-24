trigger updateContactAddress on Contact (After insert, After delete, After unDelete) {
    
       //  CHECK AFTER UPDATE TO EXECUTE THE BELOW CODE
       if( (Trigger.isInsert && Trigger.isAfter) || 
           (Trigger.isAfter && Trigger.isDelete) || 
           (Trigger.isAfter && Trigger.isUndelete) 
       ) {
       
           if(Trigger.isAfter && Trigger.isDelete) {
               System.debug(Trigger.old);
           } else if (Trigger.isAfter && Trigger.isUndelete) {
               System.debug(Trigger.new);
           } else {
               System.debug(Trigger.new);
           }
           
           Set<Id> accId = new Set<Id>();
           
           if((Trigger.isAfter && Trigger.isDelete)) {
               for(Contact idPut: Trigger.old) {
               
                   accId.add(idPut.AccountId);
               
               }
           } else if (Trigger.isAfter && Trigger.isUndelete) {
               for(Contact idPut: Trigger.new) {
               
                   accId.add(idPut.AccountId);
               
               }           
           }else {
               for(Contact idPut: Trigger.New) {
               
                   accId.add(idPut.AccountId);
               
               }
           }
                      
           // GET ACCOUNT BY AGGREGARE RESULT
           List<Account> accountList = [
               SELECT
                   Id, 
                   Name,
                   Count_Contacts__c,
                   (Select Id from Contacts)
               FROM
                   Account
               WHERE
                   Id IN: accId   
           ];
           
           System.debug(accountList);
           List<Account> actNew = new List<Account>();
           for(Account act: accountList) {               
               
               // act.Count_Contacts__c = acct.get(act.Id);
               act.Count_Contacts__c = act.contacts.size();
               actNew.add(act);
               System.debug(act);
           
           }
           
           update actNew;
           System.debug(actNew);
           
           if(Trigger.isAfter && Trigger.isDelete) {
               System.debug('Updated count');
           }
       
       }
       
       // AFTER DELEATION OF CONTACT BUT MAKE SURE ACCOUNT COUNT RECORD MUST BE UPDATE
       if( Trigger.isAfter && Trigger.isDelete ) {
       
           System.debug('Invoked---------------');
       
       }
    
}