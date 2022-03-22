/*******
* Created By : CR Team
* Cerated Date : 1 st  Feb 2022
* Description :Populate a Count of Site Accounts on the Parent Account.This class is invoked from CountSiteAccount Trigger.
* JIRA Story : 
* Modified History:
* 
* *******/

public class SetLocalTimeOnSA{
    public static void setLocalTime (List<ServiceAppointment> saTriggeredList, Map<Id,ServiceAppointment> oldSa){
        Map<Id, ServiceAppointment> saIdBySADetailsMap = new Map<Id, ServiceAppointment>();
        
     
        for(serviceappointment saRec:saTriggeredList){
            saIdBySADetailsMap.put(saRec.Id, saRec);
            
        }
        String profileName;
        Id profileId=userinfo.getProfileId();
        if(profileId != null){
            List<Profile> profileData = new List<Profile>([Select Id,Name from Profile where Id=:profileId]);
            profileName = profileData != null && profileData.size() > 0 ? profileData[0].Name : null;
        }
       
        
        for(serviceappointment sa:saTriggeredList){
             if(saIdBySADetailsMap.containsKey(sa.Id)){
             
             
        //ServiceAppointment oldSa = Trigger.oldMap.get(sa.Id); //get the old values on the SA, to reference and see if anything has changed
        if(sa.ServiceTerritoryId<>null&&sa.schedstarttime<>null&&sa.schedendtime<>null&&((oldSa.get(sa.id).schedstarttime<>sa.schedstarttime)||(oldSa.get(sa.id).schedendtime<>sa.schedendtime)||(oldSa.get(sa.id).serviceterritory<>sa.serviceterritory))){
            //check if the service territory, scheduled start or scheduled end values are null. Also check if the values for the scheduled start, end, and territory have changed. If they haven't, don't evaluate the logic.
            //system.debug('sa.sa.ServiceTerritory.OperatingHoursId>>>>> '+sa.ServiceTerritory.OperatingHoursId);
            string zone = [select id, operatinghours.timezone from serviceterritory where id=:sa.ServiceTerritoryId].operatinghours.timezone;
            Id opId = [select id, operatinghours.timezone,operatinghours.Id from serviceterritory where id=:sa.ServiceTerritoryId].operatinghours.Id;
            OperatingHours operatingHours = [SELECT Name, Id,TimeZone, (SELECT EndTime, StartTime, Type, DayOfWeek FROM TimeSlots) FROM OperatingHours WHERE Id =: opId  ];
            
            
            
            List<TimeSlot> timeSlotList = operatingHours.TimeSlots;
            system.debug('timeSlotList >>>>> '+timeSlotList );
            //grab the text value of the timezone defined on the operating hours associated to the service territory set on the service appointment
            if(zone<>null){
                timezone tz = Timezone.getTimeZone(zone); //get the timezone object for the text value
                system.debug('tz >>>> '+tz );
                system.debug('sa.schedstarttime>>>>> '+sa.schedstarttime);
                 system.debug('sa.schedendtime>>>>> '+sa.schedendtime);
                
                Integer offset = tz.getOffset(sa.schedstarttime); //get the number of milliseconds offset between UTC and the above specified timezone
                Datetime localStart = sa.schedstarttime.addSeconds(offset/1000); //local start is the scheduled start UTC, + offset from UTC in seconds
                Datetime localEnd = sa.schedendtime.addSeconds(offset/1000);//local end is the scheduled end UTC, + offset from UTC in seconds
                system.debug('localStart >>>>> '+localStart );
                 system.debug('localEnd >>>>> '+localEnd );
                sa.local_start__c = string.valueof(localStart.formatGmt('M/d/yyyy, h:mm a')); //write local times to text field, formatted 
                sa.local_end__c = string.valueof(localEnd.formatGmt('M/d/yyyy, h:mm a'));
                 
                 
                 
                 system.debug('sa.local_start__c>>>>> '+sa.local_start__c);
                 system.debug('sa.local_end__c>>>>> '+sa.local_end__c);
                 Time s = sa.schedstarttime.Time() ;
                 Time localStartTimeToCompare = localStart.Time(); 
                 String localTimeString = localStart.format('HH:mm:ss');
                   system.debug('s  schedstarttime>>>>> '+s );
                   system.debug('localStartTimeToCompare >>>>> '+localStartTimeToCompare );
                   system.debug('sa.localStart >>>>> '+localStart );
                   system.debug('localTimeString  >>>>> '+localTimeString );
                   Datetime newArrivalStart;
                   Datetime newArrivalEnd;
                   Datetime localArrivalStart;
                    Datetime localArrivalEnd;
                if(profileName != 'guest Profile'){
                    for(TimeSlot slot: timeSlotList ){
                        system.debug('slot.StartTime>>>>> '+slot.StartTime);
                         system.debug('slot.EndTime>>>>> '+slot.EndTime);
                       if(localStartTimeToCompare  >= slot.StartTime && localStartTimeToCompare  <slot.EndTime){
                           
                       
                           newArrivalStart = Datetime.newInstance(localStart.year(), localStart.month(), localStart.day(), slot.StartTime.hour() , 0, 0);
                           newArrivalEnd= Datetime.newInstance(localEnd.year(), localEnd.month(), localEnd.day(), slot.EndTime.hour() , 0, 0);
                            
                            break;
                        }
                    
                    system.debug('newArrivalStart  >>>>> '+newArrivalStart );
                    system.debug('newArrivalEnd>>>>> '+newArrivalEnd);
                    
                } 
                //sa.ArrivalWindowStartTime= newArrivalStart ; //write local times to text field, formatted 
                    //sa.ArrivalWindowEndTime= newArrivalEnd;
                    if(newArrivalStart != null && newArrivalEnd != null){
                     sa.Local_Arrival_Window_Start__c= string.valueof(newArrivalStart .formatGmt('M/d/yyyy, h:mm a')); //write local times to text field, formatted 
                    sa.Local_Arrival_Window_End__c= string.valueof(newArrivalEnd.formatGmt('M/d/yyyy, h:mm a'));
                    }
                   }
               /* if(sa.ArrivalWindowStartTime!= null && sa.ArrivalWindowEndTime!= null){
                    Datetime localArrivalStart = sa.ArrivalWindowStartTime.addSeconds(offset/1000);
                    Datetime localArrivalEnd = sa.ArrivalWindowEndTime.addSeconds(offset/1000);
                    sa.Local_Arrival_Window_Start__c= string.valueof(localArrivalStart.formatGmt('M/d/yyyy, h:mm a')); //write local times to text field, formatted 
                    sa.Local_Arrival_Window_End__c= string.valueof(localArrivalEnd.formatGmt('M/d/yyyy, h:mm a'));
                }*/
                //sa.schedstarttime= sa.ArrivalWindowStartTime;
                //sa.schedendtime = sa.ArrivalWindowEndTime;
            }
        }
        }
        
        if(sa.schedstarttime == null && sa.schedendtime == null){
            sa.Local_Arrival_Window_Start__c= '';
            sa.Local_Arrival_Window_End__c='';
            sa.local_start__c = '';
            sa.local_end__c ='';
            sa.ArrivalWindowStartTime = null;
            sa.ArrivalWindowEndTime = null;
            
        }
    }
    }
    
    public static void restrictCreationOfNewSA(List<ServiceAppointment> saTriggeredList){
        Set<Id> woIdSet = new Set<Id>();
        boolean saErrorflag = false;
        for(ServiceAppointment saRec : saTriggeredList){
            woIdSet.add(saRec.ParentRecordId);
            if(saRec .ParentRecordId!= null){
                 String woIdStr = String.valueOf(saRec .ParentRecordId);
                 if(woIdStr.startsWith('0WO')){
                    
                     saRec.Installation_Type__c = [Select Installation_Type__c from WorkOrder where Id =: saRec .ParentRecordId].Installation_Type__c ;
                 }
             }
        }
        system.debug('woIdSet>>>>> '+woIdSet);
        List<ServiceAppointment> saListFromWO = [Select Id, parentRecordId, ServiceTerritoryId,Status , Service_Type__c from ServiceAppointment where 
                                                 (Service_Type__c ='New Installation' OR Service_Type__c ='Service Appointment') And parentRecordId=:woIdSet];
        system.debug('saListFromWO >>>>> '+saListFromWO );
        
        if(saListFromWO.size()>0){
            for(ServiceAppointment saRec : saListFromWO ){
                for(ServiceAppointment saNewRec : saTriggeredList){
                    if(saNewRec.Service_Type__c =='New Installation' || saNewRec.Service_Type__c =='Service Appointment'){
                        system.debug('saRec.status>>>>> '+saRec.status);
                        if(saRec.status != 'Canceled' && saRec.status != 'Canceled - No Contact' && saRec.status != 'Cannot Complete'){
                            system.debug('inside if condition >>>>> '+saRec.status);
                            saErrorflag = true;
                            saNewRec.addError('New SA cannot be created if there is an existing SA on which work is in progress.');
                        }
                    }
                }
            }
        }
        /*for(ServiceAppointment saRec : saTriggeredList){
if(saListFromWO.isEmpty()){
saRec.addError('New SA cannot be created');
}
}*/
        
    }
    
    
}