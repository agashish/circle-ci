({
    clickCreateItem: function(component, event, helper) {        
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
            helper.createItem(component, newExpenseItem)
        }
    },
    // Load expenses from Salesforce
    doInit: function(component, event, helper) {
        // Create the action
        var action = component.get("c.getItems");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.items", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    handleAddItem: function(component, event, helper) {
        console.log(JSON.stringify(event.getParam("item")));
        const newExpenseItem = event.getParam("item")
        
        console.log('Invoking helper methid fro remote call')
		const action = component.get("c.saveItem")
        action.setParams({
            "item": newExpenseItem
        })
        
        action.setCallback(this, (response) => {
            var state = response.getState();
            if (state === "SUCCESS") {
                var items = component.get("v.items");
                items.push(response.getReturnValue());
                component.set("v.items", items);            	
            }
        })
        $A.enqueueAction(action);
    }
})