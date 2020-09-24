({
	deleteRow : function(component, event, helper) {
		const tasks = component.get("v.tasks");
        
        const rowIndex = event.getParam('rowIndex');
        tasks.splice(rowIndex, 1);
        
        component.set('v.tasks', tasks);
        
	}
})