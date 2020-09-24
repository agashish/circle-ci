({
	init : function(component, event, helper) {
        const data = [];
        data.pendingLeavesHeading = [
        	{"label": "Attendence Type"},
            {"label": "Request Date"},
            {"label": "From Date"},
            {"label": "To Date"},
            {"label": "Attendence Floating Holiday Date"},
            {"label": "No. Of Days"},
            {"label": "Approval Authority"}
        ];
        
        data.pendingLeaves = [
            {
                "leaveType": "Attendence Leave",
                "requestDate": "24-June-2020",
                "fromDate": "24-June-2020",
                "toDate": "24-June-2020",
                "floatingHolidayDate": "24-June-2020",
                "noOfDays": "24-June-2020",
                "approvalAuthority": "Person 2"
            },
            {
                "leaveType": "Attendence Leave2",
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
                "leaveType": "Attendence Leave",
                "requestDate": "24-June-2020",
                "fromDate": "24-June-2020",
                "toDate": "24-June-2020",
                "floatingHolidayDate": "",
                "noOfDays": "24-June-2020",
                "approvalAuthority": "Person 2"
            },
            {
                "leaveType": "Attendence Floating Holiday",
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
    
    openOption: function(component, event, helper) {
        if( component.find("requestType").get("v.value") != '' ) {
            component.set("v.otherOption", true)
        } else {
            component.set("v.otherOption", false)
        }
    }
})