({
    handleNext : function(component, event, helper) {
        var action  = component.get("c.getContactEmail");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            var response1=response.getReturnValue();
            console.log('==>response1'+response1);
            if(state==="SUCCESS")
            {
                component.set("v.contactEmail",response1);
                if(component.get("v.contactEmail").includes('Warning :'))
                   {
                     component.set("v.isWarning",false);
                   }
               
                component.set("v.contactEmailFalse",false);
            }
            
        });
        $A.enqueueAction(action);
    },
    handleSendEmail: function(component, event, helper){
        var action  = component.get("c.updateContactEmail");
        action.setParams({
            recordId: component.get("v.recordId"),
            "isSendEmail":"true"
        });
        action.setCallback(this,function(response){
            var state=response.getState();
            var response1=response.getReturnValue();
            console.log('==>response46');
            if(state==="SUCCESS")
            {
                component.set("v.isSendEmail",true); 
                component.set("v.contactEmail",null); 
                component.set("v.contactEmailFalse",false);
            }     
            
        });
        $A.enqueueAction(action);
        
        
    },
    handleCancel: function(component, event, helper){
        var navigateEvent = $A.get("e.force:navigateToSObject");
        navigateEvent.setParams({ "recordId": component.get('v.recordId') });
        navigateEvent.fire();
    },
    
    
    
})