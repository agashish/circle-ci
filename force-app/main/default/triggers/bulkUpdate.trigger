trigger bulkUpdate on Vpn__c (After update) {

    System.debug('Get All Vpn__c old records');
    Map<Id, Vpn__c> oldVpn = Trigger.oldMap;    
    
    System.debug('Get All Account Id');
    Set<Id> accountIds = new Set<Id>();
    
    System.debug(Trigger.new);
    
    for(Vpn__c vpn: Trigger.new) 
    {
        if(vpn.MailingStreet__c != oldVpn.get(vpn.Id).MailingStreet__c) {
            System.debug('Yes');
        } else {
            System.debug('No');
        }
    }
}