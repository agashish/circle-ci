public class QueuebleClass implements Queueable {

    public List<Account> accList;
    public QueuebleClass(List<Account> accounts) {
    
        this.accList = accounts;
    
    }
    
    public void execute(QueueableContext context) {
    
        System.debug('Start');
        
        for(Account acc: this.accList) {
        
            System.debug(acc.Name);            
        
        }         
        
        System.debug('Completed');    
    
    }
    
}