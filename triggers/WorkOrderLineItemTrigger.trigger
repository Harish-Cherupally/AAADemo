trigger WorkOrderLineItemTrigger on WorkOrderLineItem (before delete, 
                                  before update, 
                                  before insert, 
                                  after delete, 
                                  after update, 
                                  after insert,
                                  after undelete) 
{
    //TriggerRouter.handler(new CR_WorkOrderLineItemHandler());
    
    if(trigger.isBefore){
        if(trigger.isUpdate){
            CR_WOLITriggerHelper.updateAssetAfterWOLIUpdated(Trigger.New, Trigger.oldMap);
           CR_WOLITriggerHelper.assetOperationsForWOLIAddOn(Trigger.New, Trigger.oldMap);
        }
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            CR_WOLITriggerHelper.InsertAssetAfterWOLICreated(Trigger.New);
        }
    }
}