/*
Modified By: Nanda Kishore
Description: This class is created to get the slots to schedule the Service Appointment based territory and 
operating hours timezone of the service territory in which the
Service Appointment is located.
*/
global class ESWFieldServiceScheduling {
    @InvocableMethod
    global static List<ResultWrapper> getSlots(List<ESWSchedulingParameters> parameterList) {
        System.debug('beginning of getSlots');
        List<string> results = new List<string>();
        List<ResultWrapper> resWrapper = new List<ResultWrapper>();
        List<ESWFieldServiceSchedWrapper> slotWrapper = new List<ESWFieldServiceSchedWrapper>();
        for(ESWSchedulingParameters parameters : parameterList) {
            OperatingHours operatingHours = [SELECT Name, Id,TimeZone, (SELECT EndTime, StartTime, Type, DayOfWeek FROM TimeSlots) FROM OperatingHours WHERE Id =: parameters.operatingHoursId LIMIT 1];
            
            //string timeZoneOperatingHours = operatingHours.TimeZone;
         //   System.Savepoint savepoint = Database.setSavepoint();
            String originalServiceAppointmentId = parameters.serviceAppointment.Id;
            DateTime originalArrivalWindowStartTime = parameters.serviceAppointment.ArrivalWindowStartTime;
            DateTime originalArrivalWindowEndTime = parameters.serviceAppointment.ArrivalWindowEndTime;
            parameters.serviceAppointment.ArrivalWindowEndTime = null;
            parameters.serviceAppointment.ArrivalWindowStartTime = null;
            //upsert parameters.serviceAppointment;
            
            TimeZone tz = TimeZone.getTimeZone(operatingHours.TimeZone);
            
            List<FSL.AppointmentBookingSlot> slotList = FSL.AppointmentBookingService.GetSlots(
                parameters.serviceAppointment.Id,
                parameters.policyId,
                parameters.operatingHoursId,
                //UserInfo.getTimeZone(),
                tz,
                False
            );
             system.debug('slotList==='+slotList.size());
            system.debug('slotList==='+slotList);
         //   Database.rollback(savepoint);
            parameters.serviceAppointment.Id = originalServiceAppointmentId;
            parameters.serviceAppointment.ArrivalWindowStartTime = originalArrivalWindowStartTime;
            parameters.serviceAppointment.ArrivalWindowEndTime = originalArrivalWindowEndTime;
            
            List<string> slotObjects = new List<string>();
            
            List<string> slotObjects1 = new List<string>();
            Integer i =0;
            
            for(FSL.AppointmentBookingSlot slot : slotList) {
                system.debug('slot =='+slot );
                
                //slotObjects.add('{ "grade":' + slot.Grade + ', "start": "' + slot.Interval.Start + '", "finish": "' + slot.Interval.Finish + '" }');                
                    
                if(slot.Grade >=parameters.minGradeRange && slot.Grade <=parameters.maxGradeRange){
                    Integer offSet = tz.getOffset(slot.Interval.Start);
                    
                    ESWFieldServiceSchedWrapper tempWrapper = new ESWFieldServiceSchedWrapper();
                    tempWrapper.grade = slot.Grade;
                    tempWrapper.start = slot.Interval.Start.addSeconds(-(offSet/1000));
                    tempWrapper.finish = slot.Interval.Finish.addSeconds(-(offSet/1000));
                    tempWrapper.timeZoneName = tz.getID();                
                    slotWrapper.add(tempWrapper);    
                }               
            }
            
            //results.add('[' + String.join(slotObjects, ',') + ']');
            
        }
        system.debug('results=='+results.size());
        
        
        ResultWrapper tempResWrapper = new ResultWrapper();
        tempResWrapper.result = slotWrapper;
        resWrapper.add(tempResWrapper);
        
        return resWrapper;
        
    }
    
    global class ESWSchedulingParameters {
        @InvocableVariable(required=true)
        global ServiceAppointment serviceAppointment;
        
        @InvocableVariable(required=true)
        global Id policyId;
        
        @InvocableVariable(required=true)
        global id operatingHoursId ;
        
        @InvocableVariable(required=true)
        global integer maxGradeRange;
        
        @InvocableVariable(required=true)
        global integer minGradeRange;
    }
    
    global class ResultWrapper {
        @InvocableVariable
        global List<ESWFieldServiceSchedWrapper> result;
    }
    
   
}