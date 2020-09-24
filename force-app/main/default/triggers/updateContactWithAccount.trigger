trigger updateContactWithAccount on Contact (After insert, After update, After delete) {

    if((Trigger.isAfter && Trigger.isInsert) || (Trigger.isAfter && Trigger.isUpdate) || (Trigger.isAfter && Trigger.isDelete)) {
    
        System.debug('Trigger.isAfter && Trigger.isUpdate');
        List<Contact> triggerNew = new List<Contact>();
        
        if((Trigger.isAfter && Trigger.isDelete)) {
             triggerNew = Trigger.old;   
        } else {
            triggerNew = Trigger.new;   
        }
        // INITIALIZE THE CLASS        
        (new UpdateContactWithAccount()).init(triggerNew);
        
    }

}