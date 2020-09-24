({
    selectLeftMenuToOpen: function(component, event, handler) {
        
        // #### GET SELECTED LEFT NAV
        const afterSelectVerticalNavigationItem = event.getParam('name');
        // #### START TO TRIGGER EVENT
        const navLeftEvent = component.getEvent("leftNavEvent");
        navLeftEvent.setParams({
            "selectedTab": afterSelectVerticalNavigationItem
        })
        navLeftEvent.fire();
        console.log(afterSelectVerticalNavigationItem);
    },
    init: function(component, event, handler) {
       // WITHOUT LABEL
       // component.set("v.selectedMenuItemOnLoad", "leaverequestTabs") 	   
        
       // WITH CUSTOM LABEL
       component.set("v.selectedMenuItemOnLoad", $A.get("$Label.c.leaverequestTabs")) 	
       
       // #### START TO TRIGGER EVENT
        const navLeftEvent = component.getEvent("leftNavEvent");
        navLeftEvent.setParams({
            "selectedTab": component.get("v.selectedMenuItemOnLoad")
        })
        navLeftEvent.fire();
        console.log('Done');
    }
});