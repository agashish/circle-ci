({
    _SCRIPT_LOADING_ : function(component, event, helper) {
		$("document").ready(function(){
           console.log('Script is loaded and ready to use');
       });
	},
	_CREATE_TASK_ : function(component, event, helper) {
		// #### CHECK FOR EXCEPTIONS CASES
		// #### IF ITS OKAY TO PASS THE CONTROL BELOW		
        if(helper._PASSED_()($('#task-input').val())) {
            const taskList = component.get('v.tasksList')
            taskList.push($('#task-input').val());
            
            // #### SET TO COMPONENT
           	component.set('v.tasksList', taskList);
        }
	}    
})