trigger updateAccountAddress on Vpn__c (After update) {

    if(Trigger.isAfter) {
    
        System.debug('Is After Launched');        
        System.debug('-------------');
        
        System.debug('Trigger.old');
        Vpn__c oldVpn = Trigger.old[0];

        System.debug('Trigger.new');
        Vpn__c newVpn = Trigger.new[0];
        
        System.debug(newVpn); 
          
        System.debug('Query to get Account recond on the basis of @Id');
        Account acc = [Select Id, BillingStreet from Account where id =: newVpn.Account__c];
        
        if(oldVpn.mailingStreet__c != newVpn.mailingStreet__c) {
            System.debug('Yes, Should be execute well');
            acc.billingStreet = newVpn.mailingStreet__c;
            update acc;
            System.debug('Yes, Executed Account record.');
        } else {
            System.debug('Yes, Should not execute well');
            System.debug(acc);
        }    
    }
}