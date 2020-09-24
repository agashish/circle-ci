@isTest(seeAllData = false)
public class UpdateOnlyAccountTest {
    
    // 1) RUNS INTO SYSTEM MODE
    // 2) RUNS INTO USER MODE - System.runAs(){} - WILL APPLY THE PROFILE and WORKS ACCORDING TO ACCESS
    static testMethod void updateAccountByTestClass() {
        
        List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.name = 'Ashish';
        acc.Industry = 'It';
        acc.site = 'Site';
        accList.add(acc);
        
        // INSERTION
        insert accList;
        
        // List<Account> accList = [SELECT Id, Name, Site FROM Account];
        UpdateOnlyAccount uoa = new UpdateOnlyAccount();
        uoa.getAccounts(accList);
        System.debug('***************');
        System.debug('Account records :: ' + accList);
        System.debug('***************');    
        
        // ASSERT METHODS
        System.debug(accList[0]);
        System.debug(accList[0].description);
        System.assert(accList[0].description == 'Ashish-It', 'This is great1');
        System.assertEquals(accList[0].description, 'Ashish-It', 'This is great2');    
        System.assertNotEquals(accList[0].description, 'Ashish-Its', 'This is great3');
    }
}