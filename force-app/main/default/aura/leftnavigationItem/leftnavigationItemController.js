({
    init: function (component) {
        component.set('v.updatedCount', 12);
        component.set('v.selectedItem', 'leave_request');
        component.set('v.currentContent', 'leave_request');
    },
    
    handleSelect: function(component, event, helper) {
        var selected = event.getParam('name');
        component.set('v.currentContent', selected);
    }
});