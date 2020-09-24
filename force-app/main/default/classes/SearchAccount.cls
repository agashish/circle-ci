public with sharing class SearchAccount {
    
    Transient public boolean isShow {get; set;}  

    public PageReference updateInputBoxById() {
        return null;
    }

    Transient public boolean toShow { get; set; }
    
    Transient public boolean noRecords { get; set; }
    
    public string commonMessage { get; set; }

    Transient public List<Account> contactResult { get; set; }
    Transient public List<Contact> contactsList { get; set; }

    Transient public List<Account> accResult { get; set; }
    
    public string recordId {get; set;}
    
    public string accountId {get; set;}
    

    public SearchAccount() {
        toShow = false;
        noRecords = false;
        isShow = true;
        contactsList = new List<contact>();
    }

    public string searchText {get; set;}
    private string searchQueryText {get; set;}

    public SearchAccount(ApexPages.StandardController controller) {
        toShow = false;
        isShow = true;
    }
    
    public List<Account> loadContactById() {
    
        Id accId = accountId;        
        contactResult = [
            Select (Select Id, LastName from Contacts) from account Where Id = :accId
        ];
        contactsList = contactResult[0].Contacts;
        if(contactsList.size() > 0) {
        
            toShow = true;
            noRecords = false; 
        
        } else {
            noRecords = true;
            toShow = false;
            commonMessage = 'No Record Found!';
        }
                        
        return null;
    }
    
    public List<Account> searchAccount() {
    
        isShow = true;
        
        System.debug('isShow ------- : ' + isShow);
    
        System.debug('searchQueryText :: ' + searchText);
        
        searchQueryText = '%' + searchText + '%';   
        
        accResult = [
            SELECT
                Id,
                Name,
                Site,
                Description,
                (
                    SELECT
                        Id, 
                        LastName
                    FROM 
                        Contacts    
                )
            FROM
                Account
            WHERE
                name LIKE :searchQueryText        
        ];
        
        System.debug('accResult.size() : ' + accResult.size());
        system.debug('------------------ RESULTS ----------------');
        System.debug('accResult :' + accResult);
        
        if(accResult.size() > 0) {
          
            toShow = true;
        
        } else {
            toShow = false;
        }
        
        return null;
    
    }
}