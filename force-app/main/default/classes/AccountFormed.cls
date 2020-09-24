global class AccountFormed {

    webservice static void returnAccount() {
    
        List<Account> acc = [SELECT Id, Name FROM account limit 2];
        
        System.debug('-------- INVOKED ----------');
            System.debug('Account list :: ' + acc);
        System.debug('-------- INVOKED ----------');
    
    }

}