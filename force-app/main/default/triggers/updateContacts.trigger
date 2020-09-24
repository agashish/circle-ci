trigger updateContacts on Account (After update) { 

    // Account shipping address checkbox checks tha  next need to check 
    // related contact mailing must be the same otherwise produc an error to show underneath the feild.
    
    if(Trigger.isAfter && Trigger.isUpdate) {
    
        // For single record
        Map<Id, Account> oldAccount = Trigger.oldMap;
        List<Account> accRecord = Trigger.new;
        
        // GET CONTACT RECORD ACCORDING TO SPECIFIC ACCOUNT
        List<Account> contactRecord = [
            Select 
                Id, 
                Name, 
                ShippingStreet, 
                (
                    SELECT 
                        Id, 
                        LastName, 
                        AccountId, 
                        MailingStreet 
                    from 
                        Contacts
                ) 
            from 
                Account 
            WHERE 
                Id IN: Trigger.new
        ];
        
        System.debug('Record is :: ' + contactRecord);
        
        List<Contact> contactUpdateRecord = new List<Contact>();
        for(Account acc: contactRecord) {
        
            // Make Sure Ond and new muste differ from each other
            if(acc.ShippingStreet != Trigger.oldMap.get(acc.Id).ShippingStreet) {
            
                // Update Contact Begins
                System.debug('*********** TRUE UPDATE ***********');
                System.debug(acc.ShippingStreet + '<<>' + Trigger.oldMap.get(acc.Id).ShippingStreet);
                for(Contact con: acc.contacts) {
                
                    System.debug('----------');
                    System.debug('----------' + con);
                    if(con.MailingStreet != acc.ShippingStreet) {
                    
                        System.debug('----------');
                        System.debug('Not Match and going for update :: ' + con);
                        con.MailingStreet = acc.ShippingStreet;
                        contactUpdateRecord.add(con);
                        System.debug('----- ADDED INTO LIST -----');
                        
                    } else {
                    
                        System.debug('----------');
                        System.debug('Matche and not going for update');
                        System.debug('----------');
                    
                    }
                    System.debug('----------');
                
                }
                System.debug('************ TRUE UPDATE **********');
                System.debug(contactUpdateRecord);
                update contactUpdateRecord;
                System.debug('************ Updated Successfully **********');
                
            } else {
            
                System.debug('*********** FALSE UPDATE ***********');
                System.debug(acc.ShippingStreet + '<<>' + Trigger.oldMap.get(acc.Id).ShippingStreet);
                System.debug('************ FALSE UPDATE **********');
            }        
        }
    }
}