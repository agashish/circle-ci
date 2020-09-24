({
	createItem : function(component) {
		var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validExpense){
            // Create the new expense
            var newExpenseItem = component.get("v.newItem");
            console.log("Create expense: " + JSON.stringify(newExpenseItem));
            alert('done')
            var addEvent = component.getEvent("addItem");
            addEvent.setParams({ "item": newExpenseItem });
            addEvent.fire();            
            component.set("v.newItem", { 'sobjectType': 'Camping_Item__c',
                                        'Name': '',
                                        'Quantity__c': 0,
                                        'Price__c': 0,
                                        'Packed__c': false })
        }
	}
})