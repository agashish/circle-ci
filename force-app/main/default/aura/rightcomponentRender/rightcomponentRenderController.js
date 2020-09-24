({
	doInit : function(component, event, helper) {
        
        component.set("v.currentContent", 'leaverequestTabs')
        component.set("v.convertText", $A.get("$Label.c.Demo"));
        
        /*const lblName = $A.get(`$Label.c.${component.get("v.currentContent")}`);
        const componentName = $A.get(`$Label.c.${lblName}`)
        $A.createComponent( 
            `c:${lblName}`,
            {},
            function(dynamicComponent, status, error){                
                if(status === "SUCCESS") {
                    console.log(status);
                    let container = component.find("componentContainer");
                    let body = container.get("v.body");
                    container.set("v.body", dynamicComponent);
                }
            }
        )*/ 
	},
    onRender: function(component, event, helper) {
        /*// component.set("v.showSpinner", "true");
        const lblName = $A.get(`$Label.c.${component.get("v.currentContent")}`);
        const componentName = $A.get(`$Label.c.${lblName}`)
        $A.createComponent(
            `c:${lblName}`,
            {},
            function(dynamicComponent, status, error){                 
                if(status === "SUCCESS") {
                    console.log(status);
                    let container = component.find("componentContainer");
                    let body = container.get("v.body");
                    container.set("v.body", dynamicComponent);
                    // component.set("v.showSpinner", "false");
                }
            }
        )*/ 
    }          
})