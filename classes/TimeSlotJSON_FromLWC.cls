public with sharing class TimeSlotJSON_FromLWC {
    @AuraEnabled
    public static timeZone getOPTimeZone(id operatingHoursId) {
        system.debug('operatingHoursId>> '+operatingHoursId);
       // Map<date, List<String>> mapOfDatesByListOfTimes = new Map<date, List<String>>();
        
        OperatingHours operatingHours = [SELECT Name, Id,TimeZone, (SELECT EndTime, StartTime, Type, DayOfWeek FROM TimeSlots) FROM OperatingHours WHERE Id =: operatingHoursId LIMIT 1];
               
         TimeZone  timezone = TimeZone.getTimeZone(operatingHours.TimeZone);
        
        return timezone ;
    }
}