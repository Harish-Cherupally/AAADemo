/**
* @author            : Cloud Maven, Inc(support@cloudmaveninc.com)
* @last modified on  : 27-10-2021
**/
trigger OpportunityTrigger on Opportunity ( after update,before update,before insert ) {
    
    if ( Trigger.isUpdate ) {
        
        if ( Trigger.isAfter ) {
            
            if( OpportunityTriggerHelper.runTriggerOnlyOnce ){
                
                //OpportunityTriggerHelper.runTriggerOnlyOnce = false;
                
                OpportunityTriggerHelper.createAssetFromOpportunityLineItems( Trigger.OldMap, Trigger.NewMap );
                
            }
        }
    }
    
    if(Trigger.isbefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            OpportunityTriggerHelper.updateInstallTypeBasedOnZipCode(Trigger.new,Trigger.oldMap);    
        }
    }
}