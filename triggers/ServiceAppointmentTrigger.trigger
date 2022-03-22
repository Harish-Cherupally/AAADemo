trigger ServiceAppointmentTrigger on ServiceAppointment (before update, before insert, after insert, after update) {
        
    if(Trigger.isBefore){
        if(trigger.isUpdate){
            SetLocalTimeOnSA.setLocalTime(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isInsert){
            SetLocalTimeOnSA.restrictCreationOfNewSA(Trigger.new);
        }
    }
    
    if(Trigger.isAfter){
    
        if(Trigger.isInsert){
            ServiceAppointment_Trigger_Util.createSASnapshots(Trigger.new,null);
        }
        else if(Trigger.isUpdate){
            ServiceAppointment_Trigger_Util.createSASnapshots(Trigger.new,Trigger.oldMap);
        }
    }
}