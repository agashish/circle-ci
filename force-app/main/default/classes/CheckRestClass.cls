@restResource(urlMapping='/testApi/*')
global class CheckRestClass {

    @httpGet
    global static List<Account> getMethod() {
    
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        Id accId = req.requestUri.subString(req.requestUri.lastIndexOf('/') + 1);
        List<Account> acc = [Select Id, Name from Account WHERE id =: accId];
        return acc;
    
    }
    
    @httpPost
    global static void getPost() {
    
    System.debug('Post Method');
    
    
        string jsonBody = '';
        
        if(RestContext.request.requestBody != null) {
        
            jsonBody = RestContext.request.requestBody.toString();
            
        }
        
        System.debug('********** POST EXAMPLE **********');
        // system.debug(jsonBody);
        List<Account> acc = (List<Account>)System.JSON.deserialize(jsonBody , List<Account>.class);
        
        List<Account> accountUp = new List<Account>();
        for(account accObj: acc) {
        
            system.debug(accObj);
            accObj.Site = accObj.Site + accObj.Id;
            accountUp.add(accObj);
        
        }
        
        update accountUp;
        system.debug(accountUp);
    
    }

}