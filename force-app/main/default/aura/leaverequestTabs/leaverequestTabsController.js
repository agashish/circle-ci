({
    init : function(component, event, helper) {
        helper.getUserInfo(component); 
        // helper.loadLeaveData(component);
        // Set Today Date
        component.set("v.leaveRequestObject.Request_date__c", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
        
        const labelSelectEmployee = $A.get("$Label.c.Select_Employee")
        console.log(labelSelectEmployee)
        const data = [];
        data.pendingLeavesHeading = [
            {"label": "Leave Type"},
            {"label": "Request Date"},
            {"label": "From Date"},
            {"label": "To Date"},
            {"label": "Floating Holiday Date"},
            {"label": "No. Of Days"},
            {"label": "Approval Authority"},
            {"label": "Action"}
        ];
        
        data.pendingLeaves = [
            {
                "leaveType": "Earned Leave",
                "requestDate": "24-June-2020",
                "fromDate": "24-June-2020",
                "toDate": "24-June-2020",
                "floatingHolidayDate": "24-June-2020",
                "noOfDays": "24-June-2020",
                "approvalAuthority": "Person 2"
            },
            {
                "leaveType": "Earned Leave2",
                "requestDate": "27-June-2020",
                "fromDate": "29-June-2020",
                "toDate": "29-June-2020",
                "floatingHolidayDate": "",
                "noOfDays": "1",
                "approvalAuthority": "Person 2"
            }
        ];
        
        data.approvedLeaves = [
            {
                "leaveType": "Earned Leave",
                "requestDate": "24-June-2020",
                "fromDate": "24-June-2020",
                "toDate": "24-June-2020",
                "floatingHolidayDate": "",
                "noOfDays": "24-June-2020",
                "approvalAuthority": "Person 2"
            },
            {
                "leaveType": "Floating Holiday",
                "requestDate": "09-June-2020",
                "fromDate": "15-June-2020",
                "toDate": "18-June-2020",
                "floatingHolidayDate": "",
                "noOfDays": "4",
                "approvalAuthority": "Person 2"
            }
        ];        
        component.set("v.column", data.pendingLeavesHeading);
        component.set("v.pendingLeaves", data.pendingLeaves);
        component.set("v.approvedLeaves", data.approvedLeaves);        
    },
    openFlexPopup: function(component) {
        component.set("v.openPopupForFlexTimmings", "true");
    },
    closePopup: function(component) {
        component.set("v.openPopupForFlexTimmings", "false");
    },
    onchangeDateRequest: function(component, event) {
        component.set("v.openLeaveSection", "true")
    },
    onchangeDateRequestCheckboxForHalfDay: function(component, event) {
        const checkBox = component.find("startDateHalfDay").get("v.checked")
        if(checkBox) {
            component.set("v.openLeaveSection", "true")
        } else {
            component.set("v.openLeaveSection", "false")   
        }        
    },
    getDays: function(component, event, helper) {
        
        // IF START AND END DAT PROMPT
        const startDate = new Date(component.get("v.leaveRequestObject")['leave_start_date__c']);
        const endDate = new Date(component.get("v.leaveRequestObject")['leave_end_date__c']);
        if(startDate != '' && endDate != '') {
            var days = (endDate-startDate)/8.64e7; 
            if(Number.isInteger(days) && days + 1 > 0) {
            	component.set("v.noOfDaysCalculated", days + 1); 
            	component.set("v.leaveRequestObject.No_of_days__c", component.get("v.noOfDaysCalculated"));    
            } else {
                alert('Please fill start and end dates correctly.');
                component.set("v.noOfDaysCalculated", 0); 
                component.set("v.leaveRequestObject.leave_end_date__c", "");
                return;
            } 
        }
        
        component.set("v.openLeaveSection", "true")
    },
    dayCalculateOnDateType: function(component, event, helper){
        const capturedDateEvent = event.getSource().get("v.id")
        
        switch(capturedDateEvent) {
            case "earned_leave_end_date": {
                // IF START AND END DAT PROMPT  
                const startDate = new Date(component.get("v.earnLeaveStartDateValue"));
                const endDate = new Date(component.get("v.earnLeaveEndDateValue"));                                
                if(startDate != 'Invalid Date' && endDate != 'Invalid Date') {  
                    var days = (endDate-startDate)/8.64e7;
                    if(Number.isInteger(days) && days + 1 > 0) {
                        console.log(days);
                        component.set("v.earnedLeaveDays", days + 1);
                        
                        // #### ADD A TYPE WITH DATAE ALONG WITH DAYS
						let leaveArray = component.get("v.leaveTypeList"); 
                        leaveArray = [...leaveArray, {
                                Leave_Type_c: 'Earned Leave',
                                Leave_Type_Start_Date_c: component.get("v.earnLeaveStartDateValue"),
                                Leave_Type_End_Date_c: component.get("v.earnLeaveEndDateValue"),
                                No_of_days_c: days + 1 
                            }]
                        console.log(JSON.stringify(leaveArray))
                        component.set("v.leaveTypeList", leaveArray);
                        console.log('leaveTypeList if : '+component.get("v.leaveTypeList"));
                    } else {
                        alert('Please fill correct start and end date correctly.');
                        component.set("v.earnedLeaveDays", 0);
                        component.set("v.earnLeaveEndDateValue", "")
                        let leaveArray = component.get("v.leaveTypeList");
                        if (leaveArray.length > 0) {
                            leaveArray = leaveArray.filter(leave => leave.Leave_Type__c != 'Earned Leave')
                            console.log(JSON.stringify(leaveArray))
                            component.set("v.leaveTypeList", leaveArray); 
                            console.log('leaveTypeList else : '+component.get("v.leaveTypeList"));
                        }
                    }
                }
                break; 
            }
            
            case "earned_leave_start_date": {                
                // IF START AND END DAT PROMPT
                const startDate = new Date(component.get("v.earnLeaveStartDateValue"));
                const endDate = new Date(component.get("v.earnLeaveEndDateValue"));                                
                if(startDate != '' && endDate != 'Invalid Date') {
                    var days = (endDate-startDate)/8.64e7; 
                    if(Number.isInteger(days) && days + 1 > 0) {
                        console.log(days);
                        component.set("v.earnedLeaveDays", days + 1);
                    } else {
                        alert('Please fill correct start and end date correctly.');
                        component.set("v.earnedLeaveDays", 0);
                        component.set("v.earnLeaveStartDateValue", "")
                    }
                }
                break;
            }
			
			case "gen_leave_start_date": {
                // IF START AND END DAT PROMPT
                const startDate = new Date(component.get("v.genLeaveStartDateValue"));
                const endDate = new Date(component.get("v.genLeaveEndDateValue"));                                
                if(startDate != 'Invalid Date' && endDate != 'Invalid Date') {  
                    var days = (endDate-startDate)/8.64e7; 
                    if(Number.isInteger(days) && days + 1 > 0) {
                        console.log(days);
                        component.set("v.genLeaveDays", days + 1);
                    } else {
                        alert('Please fill correct start and end date correctly.');
                        component.set("v.genLeaveDays", 0);
                        component.set("v.earnLeaveStartDateValue", "")
                    }
                }
                break; 
            }
            
            case "gen_leave_end_date": {                
                // IF START AND END DAT PROMPT
                const startDate = new Date(component.get("v.genLeaveStartDateValue"));
                const endDate = new Date(component.get("v.genLeaveEndDateValue"));                                
                if(startDate != '' && endDate != 'Invalid Date') {
                    var days = (endDate-startDate)/8.64e7; 
                    if(Number.isInteger(days) && days + 1 > 0) {
                        console.log(days);
                        component.set("v.genLeaveDays", days + 1);
                        
                        let leaveArray = component.get("v.leaveTypeList");                        
                        leaveArray = [...leaveArray, {
                                Leave_Type_c: 'General Leave',
                                Leave_Type_Start_Date_c: component.get("v.genLeaveStartDateValue"),
                                Leave_Type_End_Date_c: component.get("v.genLeaveEndDateValue"),
                                No_of_days_c: days + 1
                            }]
                        
                        console.log(JSON.stringify(leaveArray)) 
                        component.set("v.leaveTypeList", leaveArray);
                    } else {
                        alert('Please fill correct start and end date correctly.');
                        component.set("v.genLeaveDays", 0);
                        component.set("v.genLeaveEndDateValue", "")
                        
                        let leaveArray = component.get("v.leaveTypeList");
                        if (leaveArray.length > 0) {
                            leaveArray = leaveArray.filter(leave => leave.Leave_Type__c != 'General Leave')
                            console.log(JSON.stringify(leaveArray))
                            component.set("v.leaveTypeList", leaveArray);                            
                        }
                    }
                }
                break;
            }
        }
    },
    addLeaveOnRequest: function(component, event, helper) {        
        // CHECK START AND END DATE WITH EARNED AND GENERAL LEAVE (START AND END) DATE
      	helper.checkAllDates(component);   
    },
    loadLeaveData: function(component, event, helper) {
        alert(1)
    },
})