@isTest(seeAllData = false)
public class QueuebleClassTest {
    
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(
                name='Test Account'+i
            ));
        }
        insert accounts;
    } 

    static testMethod void myQueuebleClassTest() {
    
        List<Account> acc = [Select id, name from Account];
        Test.startTest();
        
            System.debug('Start');
            System.enqueueJob(new QueuebleClass(acc));
            System.debug('Done');
            
        Test.stopTest();    
    
    }
    
}