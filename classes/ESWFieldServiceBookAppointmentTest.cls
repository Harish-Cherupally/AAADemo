/*Author : Hitesh Nimje 
 * Date : 02-Dec-2021
 * Desc: test class for ESWFieldServiceBookAppointment
 */

@isTest
public class ESWFieldServiceBookAppointmentTest {
   @testSetup
    static  void setupTestData(){
        
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
                                                               local_end__c = 'local266',ServiceTerritoryId = stRec.Id);
        Insert serviceApp; 
        System.debug(' @@ ServiceApp : '+ serviceApp);
        System.debug(' @@ OperatingHours : '+ ohRec);
        System.debug(' @@ Policy Id : '+ FSP);
        System.debug(' ## EarliestStartTime : '+ serviceApp.EarliestStartTime);
        System.debug(' ## DueDate : '+ serviceApp.DueDate);
        System.debug(' ## ArrivalWindowStartTime : '+ serviceApp.ArrivalWindowStartTime);
        System.debug(' ## ArrivalWindowEndTime : '+ serviceApp.ArrivalWindowEndTime);
    }
    @isTest
    static void bookAppointmentSlots() { 
        ServiceAppointment serviceApp = [SELECT id,EarliestStartTime,DueDate,ArrivalWindowStartTime,ArrivalWindowEndTime from ServiceAppointment ];
        OperatingHours oh = [SELECT Id FROM OperatingHours];
        FSL__Scheduling_Policy__c FSP =[SELECT Id,name FROM FSL__Scheduling_Policy__c];
        System.debug(' @@ ServiceApp : '+ serviceApp);
        System.debug(' @@ OperatingHours : '+ oh);
        System.debug(' @@ Policy Id : '+ FSP);
        
        List<ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentParameters> lstESWS =new List<ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentParameters>();
        ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentParameters ESWS = new ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentParameters();
        ESWS.ServiceAppointment = serviceApp;
        ESWS.operatingHoursId=oh.Id;
        ESWS.policyId=FSP.Id;
        ESWS.timeslotBegin= DateTime.now();
        ESWS.timeslotFinish= DateTime.now().addDays(2); 
        lstESWS.add(ESWS);
        
        List<ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentResult> result = ESWFieldServiceBookAppointment.bookAppointment(lstESWS);
        System.assert(result!=null);
        
    }
     @isTest
    static void bookAppointmentSlotsNegative() { 
        ServiceAppointment serviceApp = [SELECT id,ArrivalWindowStartTime,ArrivalWindowEndTime from ServiceAppointment ];
        OperatingHours oh = [SELECT Id FROM OperatingHours];
        FSL__Scheduling_Policy__c FSP =[SELECT Id,name FROM FSL__Scheduling_Policy__c];
        System.debug(' @@ ServiceApp : '+ serviceApp);
        System.debug(' @@ OperatingHours : '+ oh);
        System.debug(' @@ Policy Id : '+ FSP);
        
        List<ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentParameters> lstESWS =new List<ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentParameters>();
        ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentParameters ESWS = new ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentParameters();
        ESWS.ServiceAppointment = serviceApp;
        ESWS.operatingHoursId=oh.Id;
        ESWS.policyId=FSP.Id;
        ESWS.timeslotBegin= DateTime.now();
        ESWS.timeslotFinish= DateTime.now().addDays(2); 
        lstESWS.add(ESWS);
        
        List<ESWFieldServiceBookAppointment.ESWFieldServiceBookAppointmentResult> result = ESWFieldServiceBookAppointment.bookAppointment(lstESWS);
        System.assert(result!=null);
        
    }

}