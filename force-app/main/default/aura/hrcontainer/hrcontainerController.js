({
	handleLeftNavigationEvent : function(component, event, handler) {
        console.log("event captured", event.getParam("selectedTab"))
		component.set("v.navSelectItem", event.getParam("selectedTab"))
	}
})