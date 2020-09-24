({
	myAction : function(component, event, helper) {
        if(component.get('v.actionName') === 'customAlert') {
     		alert("Invoked custom action")       
        } else {
         	const alertMessageProps = component.get('v.alertMessage')
        	alert(alertMessageProps)   
        }   		
	},
    customAlert: function(cmp, event, helper) {
        alert('hello ji')
    }
})