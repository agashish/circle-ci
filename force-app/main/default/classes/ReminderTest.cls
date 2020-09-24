@isTest(seeAllData = false)
private class ReminderTest {

    public static String expSchTimer = '0 1 * * * ? *';
    
    @testSetUp
    public static void makeRecords() {
    
        List<Account> accUp = new List<Account>();
        for(Integer i = 0; i < 10; i++) {
        
            Account acc = new Account(
                Name = 'Test ' + i,
                Site = 'Test ' + i
            );
            
            accUp.add(acc);
        }
        
        insert accUp;
    
    }
    
    static testMethod void testExecution() {
    
        List<Account> accUp = [SELECT Id, Name, Site from Account];
        
        Map<Id, Account> accountMap = new Map<Id, Account>(accUp);
        Set<Id> accIds = new Set<Id>(accountMap.keySet());
        
        // TEST SCENARIO START
        Test.startTest();
        
        SchedulerClassTest scheduleJobForBatchProcess = new SchedulerClassTest();
        String jobId = System.schedule('Test Scheduler', expSchTimer, scheduleJobForBatchProcess);
        
        // TEST SCENARIO STOP
        Test.stopTest();
    
    }

}