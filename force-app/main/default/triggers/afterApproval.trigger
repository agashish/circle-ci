trigger afterApproval on LeaveRequest__c (after update) {
    
    if(Trigger.isAfter) {
        
        Set<Id> userIds = new Set<Id>();
        for(LeaveRequest__c empId: Trigger.new) {
            userIds.add(empId.select_employee_id__c);
        }
        
        System.debug('Trigger.newMap :: ' + Trigger.newMap.keySet());
        Map<Id, User> getUserData = new Map<Id, User>([Select Id, Name, General_Leave__c, Earned_Leave__c from User WHERE Id IN: userIds]);
        
        List<User> userList = new List<User>();
        for(LeaveRequest__c leaveObj: Trigger.new) {
        
            User updateUser = new User();
            if(leaveObj.Leave_Status__c == 'Denied') {
            
                System.debug('leaveObj : ' + leaveObj);                
                
                System.debug('leaveObj.Leave_Type__c :: ' + leaveObj.Leave_Type__c );
                switch on leaveObj.Leave_Type__c {
                
                    when 'Earned Leave' {
                        getUserData.get(leaveObj.select_employee_id__c).Earned_Leave__c = getUserData.get(leaveObj.select_employee_id__c).Earned_Leave__c + leaveObj.No_of_days__c;
                        System.debug('getUserData.Earned_Leave__c : ' + getUserData);
                        break; 
                    }
                    
                    when 'General Leave' {
                        getUserData.get(leaveObj.select_employee_id__c).General_Leave__c = getUserData.get(leaveObj.select_employee_id__c).General_Leave__c + leaveObj.No_of_days__c;    
                        System.debug('getUserData.General_Leave__c : ' + getUserData);                        
                        break;
                    }
                    
                    when else {
                        System.debug('Test Debug');
                        break;
                    }
                
                }
            
            }                               
        }
    update getUserData.values();   
    }
        
}