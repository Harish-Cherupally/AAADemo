/*
Modified By: Nanda Kishore
Description: This class is created to Schedule the Service Appointment based on the selected time slot and 
operating hours timezone of the service territory in which the
Service Appointment is located. And update start Time and End time on the Service appointment .
*/
global class ESWFieldServiceBookAppointment {
    @InvocableMethod
    global static List<ESWFieldServiceBookAppointmentResult> bookAppointment(List<ESWFieldServiceBookAppointmentParameters> parameterList) {
        List<ESWFieldServiceBookAppointmentResult> results = new List<ESWFieldServiceBookAppointmentResult>();
        
        for(ESWFieldServiceBookAppointmentParameters parameters : parameterList) {
            ESWFieldServiceBookAppointmentResult result = new ESWFieldServiceBookAppointmentResult();
            ServiceAppointment appointment = parameters.serviceAppointment;
            String originalAppointmentId = appointment.Id;
           //System.Savepoint savepoint = Database.setSavepoint();
            try {
                // Find the slot that matches the interval.
                OperatingHours operatingHours = [SELECT Name, Id,TimeZone, (SELECT EndTime, StartTime, Type, DayOfWeek FROM TimeSlots) FROM OperatingHours WHERE Id =: parameters.operatingHoursId LIMIT 1];
                //TimeZone timezone = UserInfo.getTimeZone();
                //TimeZone timezone = new TimeZone();
                //if(operatingHoursList.size()>0){
                 TimeZone  timezone = TimeZone.getTimeZone(operatingHours.TimeZone);
                 system.debug('timezone>>>'+timezone);
                 system.debug('parameters.timeslotBegin>>>'+parameters.timeslotBegin);
                 system.debug('parameters.timeslotFinish>>>'+parameters.timeslotFinish);
                 
                 
                 
                 //}
                //String timezoneString = operatingHours.TimeZone;
                DateTime originalStartTime = appointment.EarliestStartTime;
                DateTime originalDueDate = appointment.DueDate;
                DateTime originalArrivalWindowStartTime = appointment.ArrivalWindowStartTime;
                DateTime originalArrivalWindowEndTime = appointment.ArrivalWindowEndTime;
                
                // Update service appointment so that the slot validation searches in the correct range.
                appointment.ArrivalWindowEndTime = parameters.timeslotFinish.addHours(0);
                appointment.ArrivalWindowStartTime = parameters.timeslotBegin.addHours(0);
                
                appointment.EarliestStartTime = parameters.timeslotBegin.addDays(0);
                //appointment.EarliestStartTime = parameters.timeslotBegin.addHours(-1);
                appointment.DueDate = parameters.timeslotFinish.addDays(1);
                //appointment.DueDate = parameters.timeslotFinish.addHours(1); 
                //A3SHCRSF3-2: Updated Self-Schedule to True by removing in flow               
                appointment.Self_Scheduled__c = true;
               
                
               upsert appointment;
                FSL.ScheduleResult scheduleResult = FSL.ScheduleService.Schedule(parameters.policyId, appointment.Id);
                
                if(scheduleResult == null) {
                    result.success = false;
                    result.message = 'That timeslot is no longer available.';
                    appointment.EarliestStartTime = originalStartTime;
                    appointment.DueDate = originalDueDate;
                    appointment.ArrivalWindowStartTime = originalArrivalWindowStartTime;
                    appointment.ArrivalWindowEndTime = originalArrivalWindowEndTime;
                    //Database.rollback(savepoint);
                    appointment.Id = originalAppointmentId;
                } else {
                    result.success = true;
                }
            } catch(Exception e) {
              result.success = false;
              result.message = e.getMessage();
             //Database.rollback(savepoint);
              appointment.Id = originalAppointmentId;
            }
            
            results.add(result);
        }
        
        return results;
    }
    
    public static DateTime convertToTimeZone(Datetime dt, String locale) {
        Integer msPerHour = 1000 * 60 * 60;
        return dt.addHours(
            TimeZone.getTimeZone(locale).getOffset(dt) / msPerHour
        );
    }
    
    global class ESWFieldServiceBookAppointmentResult {
        @InvocableVariable
        global boolean success;
        
        @InvocableVariable
        global string message;
    }
    
    global class ESWFieldServiceBookAppointmentParameters {
        @InvocableVariable(required=true)
        global ServiceAppointment serviceAppointment;
        
        @InvocableVariable(required=true)
        global Id policyId;
        
        @InvocableVariable(required=true)
        global Id operatingHoursId;
                
        @InvocableVariable(required=true)
        global DateTime timeslotBegin;
        
        @InvocableVariable(required=true)
        global DateTime timeslotFinish;
    }
}