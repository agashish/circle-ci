public class ApexTransactionExample {
    public void checkTransaction(String accountName, String contactName, String titleMatch) {
        
        Account acc = new Account(Name=accountName);
        insert acc;
        
        Contact contact1 = new Contact(FirstName='Contact1', LastName=contactName, Title=titleMatch); // ISSUE - ?
        insert contact1;
        
        Contact contact2 = new Contact(FirstName='Contact2', LastName='User2', Title='MYTUTORIAL');
        insert contact2;
        
    }
}