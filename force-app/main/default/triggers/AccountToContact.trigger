trigger AccountToContact on Account(after insert) {

    
    List<Contact> addContact = new List<Contact>();
    
    if(Trigger.isAfter) {
    
        System.debug('Trigger.isAfter');
    
        for(Account acc: Trigger.new) {
    
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.Id;
            con.Title = 'MYTUTORIAL';
            addContact.add(con);                                
        
        }
        
        insert addContact;  
    
    }

}