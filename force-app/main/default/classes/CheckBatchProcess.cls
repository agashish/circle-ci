global class CheckBatchProcess implements Database.Batchable<sObject>, Database.Stateful {

    private List<Account> accUp = new List<Account>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
    
        String queryString = 'SELECT Id, Name, Site, description from Account LIMIT 5';
        return Database.getQueryLocator(queryString);
    
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList) {
    
        // EXECUTE OUTSIDE
        this.scrollingRecords(accList);
        
    }
    
    private void scrollingRecords(List<Account> accList) {
    
        for(Account acc: accList) {
        
            if(acc.Site != '') {
            
                acc.description = 'New Data';
                acc.Site = 'New Data';
                accUp.add(acc);
            
            } else {
                
                acc.Site = 'Its Blank buddy';
                accUp.add(acc);
                
            }
            
            
            System.debug( '[Site + Description] : ' + acc);
        
        }
        
        // update accUp;
        
        // TO PREVENT FAILS EXECUTION OF BATCH IF ERROR OCCURED
        // SO WE MUST USE DATABASE.SAVERESULT CLASS FOR PARTIALLY UPDATE
        Database.SaveResult[] srv = Database.update(accUp, false);
        for(Database.SaveResult sr: srv) {
            
            if(sr.isSuccess()) {
            
                System.debug('Successfully Inserted/Updated');
            
            } else {
            
                for(Database.Error err: sr.getErrors()) {
                
                    System.debug('Proceed with below errors');    
                    System.debug('Status code :: ' + err.getStatusCode());    
                    System.debug('Error Message :: ' + err.getMessage());    
                    System.debug('Error Feild :: ' + err.getFields());    
                
                }
            
            }
        
        }
    
    }
    
    global void finish(Database.BatchableContext bc) {
    
        System.debug('----------Complete Job-----------');
        AsyncApexJob aaj = [
            SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed, TotalJobItems, CreatedBy.Email    
            FROM AsyncApexJob
            WHERE
            Id =: bc.getJobId()
        ];
        System.debug('Batch Results : ' + aaj );
        
        System.debug('Are we getting records after execution ?');
        System.debug('accUp -> ' + accUp.size());
        
        // Get Object Id after execution how many were executed into above batch process
        for(Integer i = 0; i < accUp.size(); i++) {
        
            System.debug('Id is :: ' + accUp.get(i).Id);
        
        }
    
    }

}