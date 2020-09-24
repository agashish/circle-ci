@isTest(seeAllData = true)
public class UpdateContactWithAccountTest {
    static testMethod void updateAccount() {
        List<Contact> acc = [SELECT Id, Name, AccountId, Type__c, Amount_x__c, Amount_y__c  FROM Contact WHERE id = '0030o00002wFxcp'];
        acc[0].Amount_x__c = 5;
        update acc;
        System.debug('Contact List :: ' + acc);
    }
}