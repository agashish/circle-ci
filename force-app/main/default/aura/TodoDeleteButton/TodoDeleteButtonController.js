({
	deleteRow : function(component, event, helper) {
        const rowId = component.get("v.rowIndex")
        
        const eventTrigger = $A.get("e.c:TodoDeleteEvent");
        eventTrigger.setParam("rowIndex", rowId);
        eventTrigger.fire();
	}
})