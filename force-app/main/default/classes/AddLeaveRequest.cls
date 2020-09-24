public class AddLeaveRequest {
    
    public static Boolean isLeaveAdded;
        
    @AuraEnabled
    public static CustomStructure addLeave(LeaveRequest__c leaveRequestObject, List<LeaveJson> leaveJson) {
        
        AddLeaveRequest.isLeaveAdded =  true;

        List<Leave__c> leaveIds = new List<Leave__c>();
        leaveIds = [Select id from Leave__c Where leave_start_date__c != null
                        AND
            (
                (
                    leave_start_date__c >=: leaveRequestObject.leave_start_date__c 
                        AND 
                    leave_start_date__c <=: leaveRequestObject.leave_end_date__c
                )
                        OR
                (
                    leave_end_date__c >=: leaveRequestObject.leave_start_date__c 
                        AND 
                    leave_end_date__c <=: leaveRequestObject.leave_end_date__c
                )
           )
                    AND
            Employee_Name__c =: Userinfo.getUserId()
        ];
                 
        System.debug('leaveIds :: ' + leaveIds);
        System.debug('AddLeaveRequest.isLeaveAdded :: ' + AddLeaveRequest.isLeaveAdded);
        
        if(leaveIds.size() > 0) {
            AddLeaveRequest.isLeaveAdded = false;
        }
        else if (leaveIds.size() == 0) {            
            
            // #### PREEVENT TO INSERT LEAVE RECORDS
            Leave__c leavePrt = new Leave__c();
            leavePrt.Employee_Name__c = Userinfo.getUserId();
            leavePrt.leave_start_date__c = leaveRequestObject.leave_start_date__c;
            leavePrt.leave_end_date__c = leaveRequestObject.leave_end_date__c;
            leavePrt.Manager_Name__c = leaveRequestObject.Manager_Id__c;
            leavePrt.No_of_days__c = 1;
            leavePrt.Reason__c = 'TEST';
            leavePrt.Request_date__c = leaveRequestObject.Request_date__c;            
            system.debug('leavePrt :: ' + leavePrt);            
            insert leavePrt;            
            System.debug('leavePrt.id :: ' + leavePrt.Id);
           	System.debug('leavePrt.id :: ' + leavePrt.Reason__c);
            
            List<LeaveRequest__c> leave = new List<LeaveRequest__c>();
            Double earnLeaveDaysCount = 0.0;
            Double genLeaveDaysCount = 0.0;
            
            // USER SECTION STARTS
            Id userId = UserInfo.getUserId();
            User userData = [Select Id, Earned_Leave__c, General_Leave__c from user WHERE Id =: userId ];
            
            for(LeaveJson lj: leaveJson) {                        
                LeaveRequest__c leaveObj = new LeaveRequest__c();
                leaveObj.Leave_Master__c = leavePrt.Id;
                leaveObj.Manager_Name__c = leaveRequestObject.Manager_Name__c;
                leaveObj.Manager_Id__c = leaveRequestObject.Manager_Id__c;
                leaveObj.Leave_Type_End_Date__c = leaveRequestObject.Leave_Type_End_Date__c;
                leaveObj.leave_start_date__c = leaveRequestObject.leave_start_date__c;
                leaveObj.leave_end_date__c = leaveRequestObject.leave_end_date__c;
                leaveObj.Request_date__c = leaveRequestObject.Request_date__c;
                leaveObj.reason__c = leaveRequestObject.reason__c;
                leaveObj.Leave_Type__c = leaveRequestObject.Leave_Type__c;            
                leaveObj.No_of_days__c = leaveRequestObject.No_of_days__c;
                leaveObj.Select_Employee__c = leaveRequestObject.Select_Employee__c;
                leaveObj.select_employee_id__c = leaveRequestObject.select_employee_id__c;
                leaveObj.Leave_Type_Start_Date__c = leaveRequestObject.Leave_Type_Start_Date__c;
                leaveObj.Start_Half_Day__c = leaveRequestObject.Start_Half_Day__c;
                leaveObj.Leave_Status__c = leaveRequestObject.Leave_Status__c;
                leaveObj.End_Half_Day__c = '';
                leaveObj.No_of_days__c = lj.No_of_days_c;
                leaveObj.Leave_Type_End_Date__c = lj.Leave_Type_End_Date_c;
                leaveObj.Leave_Type_Start_Date__c = lj.Leave_Type_Start_Date_c;
                leaveObj.Leave_Type__c = lj.Leave_Type_c;
                
                // leaveObj.Start_Half_Day_Type__c = leaveRequestObject.Start_Half_Day_Type__c;
                // leaveObj.End_Half_Day_Type__c = leaveRequestObject.End_Half_Day_Type__c;
                
                // JUST CHECK
                if(lj.Leave_Type_c == 'Earned Leave') {
                    earnLeaveDaysCount = lj.No_of_days_c;
                    
                    if(leaveObj.Start_Half_Day_Type__c != '' && leaveObj.leave_start_date__c == leaveObj.Leave_Type_Start_Date__c) {
                        userData.Earned_Leave__c = userData.Earned_Leave__c - (earnLeaveDaysCount - 0.5);  
                        leaveObj.Start_Half_Day_Type__c = leaveRequestObject.Start_Half_Day_Type__c;
                    }
                    
                    if(leaveObj.End_Half_Day_Type__c != '' && leaveObj.leave_end_date__c == leaveObj.Leave_Type_End_Date__c) {
                        userData.Earned_Leave__c = userData.Earned_Leave__c - (earnLeaveDaysCount - 0.5);  
                        leaveObj.End_Half_Day_Type__c = leaveRequestObject.End_Half_Day_Type__c;
                    }
                    
                    if(leaveObj.Start_Half_Day_Type__c == '' && leaveObj.End_Half_Day_Type__c == '') {
                        userData.Earned_Leave__c = userData.Earned_Leave__c - earnLeaveDaysCount;
                    }
                    
                }  
                
                if(lj.Leave_Type_c == 'General Leave') {
                    genLeaveDaysCount = lj.No_of_days_c;
                    
                    if(leaveObj.Start_Half_Day_Type__c != '' && leaveObj.leave_start_date__c == leaveObj.Leave_Type_Start_Date__c) {
                        userData.General_Leave__c = userData.General_Leave__c - (genLeaveDaysCount - 0.5);  
                        leaveObj.Start_Half_Day_Type__c = leaveRequestObject.Start_Half_Day_Type__c;
                    }
                    
                    if(leaveObj.End_Half_Day_Type__c != '' && leaveObj.leave_end_date__c == leaveObj.Leave_Type_End_Date__c) {
                        userData.General_Leave__c = userData.General_Leave__c - (genLeaveDaysCount - 0.5); 
                        leaveObj.End_Half_Day_Type__c = leaveRequestObject.End_Half_Day_Type__c;
                    }
                    
                    if(leaveObj.Start_Half_Day_Type__c == '' && leaveObj.End_Half_Day_Type__c == '') {
                        userData.Earned_Leave__c = userData.General_Leave__c - genLeaveDaysCount;
                    }
                    
                }
                
                leave.add(leaveObj);          
            }
            
            // NOW INSERTION ACTIONED
            try {           
                if(AddLeaveRequest.isLeaveAdded) {
                    System.debug('leave :: ' + leave);
                   	insert leave;
                    
                    System.debug('userData : ' + userData);
                    update userData;    
                } else {
                    AddLeaveRequest.isLeaveAdded = false;
                }
            } catch(Exception execption) {
                System.debug('Error occured');
                System.debug(execption.getLineNumber());
                System.debug(execption.getCause());
                System.debug(execption.getMessage());
                System.debug(execption.getStackTraceString());
            }
            
        }
        System.debug('AddLeaveRequest.isLeaveAdded :: ' + AddLeaveRequest.isLeaveAdded);
        
    return getUserInfo();
    }
    
    @AuraEnabled
    public static CustomStructure getUserInfo() {        
        User user = [SELECT 
                     Id, Name, email, phone, Username, General_Leave__c, Earned_Leave__c, ManagerId, Manager.Name from User where Id =: UserInfo.getUserId()];
        List<LeaveRequest__c> leavesApproved = [SELECT 
                                        Id, 
                                        End_Half_Day__c,
                                        leave_end_date__c,
                                        leave_start_date__c,
                                        Leave_Status__c,
                                        Leave_Type__c,
                                        Manager_Id__c,                                        
                                        Manager_Name__c,
                                        No_of_days__c,
                                        reason__c,
                                        Request_date__c,
                                        Select_Employee__c,
                                        select_employee_id__c,
                                        Start_Half_Day__c
                                        from 
                                        LeaveRequest__c Where select_employee_id__c =: Userinfo.getUserId() AND Leave_Status__c = 'Approved'];
        
        List<LeaveRequest__c> leavesNotApproved = [SELECT 
                                        Id, 
                                        End_Half_Day__c,
                                        leave_end_date__c,
                                        leave_start_date__c,
                                        Leave_Status__c,
                                        Leave_Type__c,
                                        Manager_Id__c,                                        
                                        Manager_Name__c,
                                        No_of_days__c,
                                        reason__c,
                                        Request_date__c,
                                        Select_Employee__c,
                                        select_employee_id__c,
                                        Start_Half_Day__c
                                        from 
                                        LeaveRequest__c Where select_employee_id__c =: Userinfo.getUserId() AND (Leave_Status__c != 'Approved' AND Leave_Status__c != '')];
        
        /*CustomStructure customObject = new CustomStructure();
        customObject.user = user;
        customObject.leavesApproved = leavesApproved;
        customObject.leavesNotApproved = leavesNotApproved;
        
        System.debug('customObject: ' + customObject);
        return customObject;*/
        
        return new CustomStructure(user, leavesApproved, leavesNotApproved);
    }
     
    public class CustomStructure
    {
        @AuraEnabled
        public User user {get; set;}
        
        @AuraEnabled
        public List<LeaveRequest__c> leavesApproved; 
        
        @AuraEnabled
        public List<LeaveRequest__c> leavesNotApproved;
          
        @AuraEnabled
        public Boolean isLeaveAdded;
        
        public CustomStructure(User user, List<LeaveRequest__c> leavesApproved, List<LeaveRequest__c> leavesNotApproved) {
            this.user = user;    
            this.leavesApproved = leavesApproved;    
            this.leavesNotApproved = leavesNotApproved;
            this.isLeaveAdded = AddLeaveRequest.isLeaveAdded;
        }        
    }

    public class LeaveJson 
    {
        @AuraEnabled
        public String Leave_Type_c{get;set;}
        
        @AuraEnabled
        public Date Leave_Type_Start_Date_c{get;set;}
        
        @AuraEnabled
        public Date Leave_Type_End_Date_c{get;set;}
        
        @AuraEnabled
        public Double No_of_days_c{get;set;}
    }
    
    @AuraEnabled
    public static CustomStructure updateLeave(LeaveRequest__c leave) {
        update leave;
        System.debug(leave);
        return getUserInfo();
    }
}