({
	init : function(component, event, helper) {
		console.log(JSON.stringify(component.get("v.data")))
	},
    leaveDeny: function(component, event, helper) {
		let leaveData = event.getSource().get("v.value");
        console.log(leaveData.Leave_Status__c)
        console.log(leaveData)
        leaveData.Leave_Status__c = "Denied";
        console.log(leaveData.Leave_Status__c)
        console.log(leaveData)
        
        const action = component.get("c.updateLeave");
        action.setParams({
            leave: leaveData
        })
        action.setCallback(this, function(response) {
			let state = response.getState();				            
            if (state === "SUCCESS") { 
                console.log(response.getReturnValue());
                const leaveDenyEvent = component.getEvent("leaveUpdateEvent");
                console.log('leaveDenyEvent :: ', leaveDenyEvent);
				leaveDenyEvent.fire();            
            } else if (state === "INCOMPLETE") {
                console.log('Waiting...')
            } else if (state === "ERROR") {}
        });
        $A.enqueueAction(action);
    }
})