@isTest 
public class SA_ReUpdateScheduleStart_BatchTest
{
    static testMethod void testMethod1() 
    {
    
        Account account_Obj= new Account ();
        account_Obj.Name = 'Test Account';
        insert account_Obj;
        
        OperatingHours ohRec= new OperatingHours();
        ohRec.Name = 'test operting hours';
        insert ohRec;
        
        ServiceTerritory stRec= new ServiceTerritory();
        stRec.OperatingHoursId = ohRec.Id;
        stRec.Name = 'Test territory';
        stRec.IsActive = true;
        insert stRec;
        
        FSL__Scheduling_Policy__c FSP = new FSL__Scheduling_Policy__c();
        FSP.name = 'test';
        insert FSP;
        List<ServiceAppointment> lstServiceAppointment= new List<ServiceAppointment>();
        ServiceAppointment serviceApp = new ServiceAppointment(ParentRecordId = account_Obj.id, 
                                                               EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), ArrivalWindowStartTime= DateTime.now() ,
                                                               ArrivalWindowEndTime =  DateTime.now(),SchedStartTime = DateTime.now(), 
                                                               SchedEndTime = DateTime.now(), ActualStartTime = DateTime.now(), ActualEndTime = DateTime.now(), 
                                                               FSL__Auto_Schedule__c = false, FSL__Emergency__c = false, FSL__InJeopardy__c = false, FSL__IsFillInCandidate__c = false,
                                                               FSL__IsMultiDay__c = false, FSL__Pinned__c = false, FSL__Prevent_Geocoding_For_Chatter_Actions__c = false,
                                                               FSL__Same_Day__c = false, FSL__Same_Resource__c = false, FSL__Schedule_over_lower_priority_appointment__c = false, 
                                                               FSL__UpdatedByOptimization__c = false, FSL__Use_Async_Logic__c = false, 
                                                               FSL__Virtual_Service_For_Chatter_Action__c = false, Created_by_Rider__c = false, 
                                                               Self_Schedule_Appt_Confirmed__c = false, In_Scheduler__c = false, local_start__c = 'local413', 
                                                               local_end__c = 'local266',ServiceTerritoryId = stRec.Id,Original_Schedule_Start__c = DateTime.now(), Status = 'Scheduled');
        Insert serviceApp; 
        
        //insert lstAccount;
        
         //serviceApp.SchedStartTime = serviceApp.Original_Schedule_Start__c;//dt.addMinutes(-1);
            //serviceApp.Original_Schedule_Start__c = null;
            //update serviceApp;
        Test.startTest();

            SA_ReUpdateScheduleStart_Batch obj = new SA_ReUpdateScheduleStart_Batch ();
            DataBase.executeBatch(obj); 
            SA_ReUpdateScheduleStart_Batch sh1 = new SA_ReUpdateScheduleStart_Batch ();
            String sch = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check', sch, sh1); 
            
        Test.stopTest();
    }
}