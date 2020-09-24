({
	init : function(component, event, helper) {
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
            {"label": "Approval Authority"}
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
    }
})