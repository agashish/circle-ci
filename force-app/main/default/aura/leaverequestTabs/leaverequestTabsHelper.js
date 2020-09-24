({
	addLeaveRequest : function(component, leaveRequestObject) {
       	const leaveJson = component.get("v.leaveTypeList");
        console.log('leaveTypeList : '+ JSON.stringify(leaveJson));  
        console.log('leaveRequestObject :: ' + JSON.stringify(leaveRequestObject));

        const addLeaveAction = component.get("c.addLeave");
        addLeaveAction.setParams({
            "leaveRequestObject": leaveRequestObject,
            "leaveJson": leaveJson 
        });
        
        addLeaveAction.setCallback(this, function(response) { 

            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                
                // JUST CHECK IF DIDNT INSERT LEAVE IN SALESFORCE DATABASE
                if( response.getReturnValue().isLeaveAdded ) {
                	// console.log("Response Came :", response.getReturnValue());
                    console.log("Response Came :", response.getReturnValue().user.Id);
                    console.log("Response Came :", response.getReturnValue().user.ManagerId);
                    console.log("Response Came :", response.getReturnValue().user.Name);
                    console.log("Response Came :", response.getReturnValue().user.Manager.Name);
                    
                    let leaveTupple = component.get("v.leaveRequestObject");
                    leaveTupple.Manager_Id__c = response.getReturnValue().user.ManagerId;
                    leaveTupple.Select_Employee__c = response.getReturnValue().user.Name;
                    leaveTupple.select_employee_id__c = response.getReturnValue().user.Id;
                    leaveTupple.Manager_Name__c = response.getReturnValue().user.Manager.Name;                
                    component.set("v.leaveRequestObject", leaveTupple);
                    console.log(JSON.stringify(component.get("v.leaveRequestObject")));
                    
                    component.set("v.approvedLeaves", response.getReturnValue().leavesApproved )
                    component.set("v.pendingLeaves", response.getReturnValue().leavesNotApproved )
                    component.set("v.user_gen_leave", response.getReturnValue().user.General_Leave__c)
                    component.set("v.user_earn_leave", response.getReturnValue().user.Earned_Leave__c)    
                } else {
                    alert( 'You have already applied the leave on the baiss of your start and end date. \n Please correct it once, Try it again.' );
                    return false;
                }
            }
            else if (state === "INCOMPLETE") {
                console.log('Waiting...')
            }

            else if (state === "ERROR") {}
        });
        $A.enqueueAction(addLeaveAction);
	},
    getUserInfo : function(component) {
        const action = component.get("c.getUserInfo");
        action.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                
                // console.log("Response Came :", response.getReturnValue());
                console.log("Response Came :", response.getReturnValue().user.Id);
                console.log("Response Came :", response.getReturnValue().user.ManagerId);
                console.log("Response Came :", response.getReturnValue().user.Name);
                console.log("Response Came :", response.getReturnValue().user.Manager.Name);
                
                let leaveTupple = component.get("v.leaveRequestObject");
                leaveTupple.Manager_Id__c = response.getReturnValue().user.ManagerId;
                leaveTupple.Select_Employee__c = response.getReturnValue().user.Name;
                leaveTupple.select_employee_id__c = response.getReturnValue().user.Id;
                leaveTupple.Manager_Name__c = response.getReturnValue().user.Manager.Name;                
                component.set("v.leaveRequestObject", leaveTupple);
                console.log(JSON.stringify(component.get("v.leaveRequestObject")));
                
                component.set("v.approvedLeaves", response.getReturnValue().leavesApproved )
                component.set("v.pendingLeaves", response.getReturnValue().leavesNotApproved )
                component.set("v.user_gen_leave", response.getReturnValue().user.General_Leave__c)
                component.set("v.user_earn_leave", response.getReturnValue().user.Earned_Leave__c)
            }
            else if (state === "INCOMPLETE") {
                console.log('Waiting...')
            }

            else if (state === "ERROR") {}
        });

        $A.enqueueAction(action);
	},
    checkAllDates: function(component) {
        // WE WILL CHECK FIRST START DATE WITH LEAVE TYPE START DATE ONLY
        this.getDays(component);
    },
    getDays: function(component) {        
        // IF START AND END DATE PROMPT
        const startDate = new Date(component.get("v.leaveRequestObject")['leave_start_date__c']);
        const endDate = new Date(component.get("v.leaveRequestObject")['leave_end_date__c']);
        
		const earnLeaveStartDateValue 	= new Date(component.get("v.earnLeaveStartDateValue"));
        const earnLeaveEndDateValue 	= new Date(component.get("v.earnLeaveEndDateValue"));
        const genLeaveStartDateValue 	= new Date(component.get("v.genLeaveStartDateValue"));
        const genLeaveEndDateValue 		= new Date(component.get("v.genLeaveEndDateValue"));        
        let isDateOkay = true;
        
        // PASS AND CHECK THROUGH INNER LOCALITIES
        // CASE 1
        if(!this.dayCalculate(startDate, earnLeaveStartDateValue, 1)) {
            isDateOkay = false;
            console.log('this.dayCalculate(startDate, earnLeaveStartDateValue, 1) : ' + isDateOkay);
            return false;
        } else if(!this.dayCalculate(startDate, genLeaveStartDateValue, 1)) {
            isDateOkay = false;
            console.log('this.dayCalculate(startDate, genLeaveStartDateValue, 1) : ' + isDateOkay);
            return false;
        } else if (!this.dayCalculate(endDate, earnLeaveEndDateValue, 2)) {
            isDateOkay = false;
            console.log('this.dayCalculate(endDate, earnLeaveEndDateValue, 2) : ' + isDateOkay);
            return false;
        } else if(!this.dayCalculate(endDate, genLeaveEndDateValue, 2)) {
            isDateOkay = false;
            console.log('this.dayCalculate(endDate, genLeaveEndDateValue, 2) : ' + isDateOkay);
            return false;
        } else {}
		
        const leaveRequestObject = component.get("v.leaveRequestObject");        
        this.addLeaveRequest(component, leaveRequestObject); 
    },
    dayCalculate: function(date1, date2, direction) {
        let isDateOkay = true;
        switch(direction) {
            case 1: {
            	if(date1 != '' && date2 != '') {
                    var days = (date2-date1)/8.64e7;             
                    if(Number.isInteger(days) && days < 0) {
                        // alert('Error Occured - Start Dates');
                        isDateOkay =  false;
                    }
                }
                break;
			}
			case 2: {
            	if(date1 != '' && date2 != '') {                  
                    var days = (date1-date2)/8.64e7;             
                    if(Number.isInteger(days) && days < 0) {
                        // alert('Error Occured - End Dates');
                        isDateOkay =  false;
                    }
                }
                break;
			} 
            default: {
                break;
            }                
		}   
        // alert('isDateOkay : ' + isDateOkay);
        return isDateOkay;
    }
})