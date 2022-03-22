/*Author : Hitesh Nimje 
 * Date : 02-Dec-2021
 * Desc: test class for ESWFieldServiceScheduling
 */

@isTest
public class ESWFieldServiceSchedulingTest {
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
                                                               EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), SchedStartTime = DateTime.now(), 
                                                               SchedEndTime = DateTime.now(), ActualStartTime = DateTime.now(), ActualEndTime = DateTime.now(), 
                                                               FSL__Auto_Schedule__c = false, FSL__Emergency__c = false, FSL__InJeopardy__c = false, FSL__IsFillInCandidate__c = false,
                                                               FSL__IsMultiDay__c = false, FSL__Pinned__c = false, FSL__Prevent_Geocoding_For_Chatter_Actions__c = false,
                                                               FSL__Same_Day__c = false, FSL__Same_Resource__c = false, FSL__Schedule_over_lower_priority_appointment__c = false, 
                                                               FSL__UpdatedByOptimization__c = false, FSL__Use_Async_Logic__c = false, 
                                                               FSL__Virtual_Service_For_Chatter_Action__c = false, Created_by_Rider__c = false, 
                                                               Self_Schedule_Appt_Confirmed__c = false, In_Scheduler__c = false, local_start__c = 'local413', 
                                                               local_end__c = 'local266',ServiceTerritoryId = stRec.Id,ArrivalWindowStartTime = DateTime.now(),ArrivalWindowEndTime=DateTime.now());
        Insert serviceApp; 
        System.debug(' @@ ServiceApp : '+ serviceApp);
        System.debug(' @@ OperatingHours : '+ ohRec);
        System.debug(' @@ Policy Id : '+ FSP);
    }
    
    static testMethod void testgetSlots() { 
        ServiceAppointment serviceApp = [SELECT id,ArrivalWindowStartTime,ArrivalWindowEndTime from ServiceAppointment ];
        OperatingHours oh = [SELECT Id FROM OperatingHours];
        FSL__Scheduling_Policy__c FSP =[SELECT Id,name FROM FSL__Scheduling_Policy__c];
        System.debug(' @@ ServiceApp : '+ serviceApp);
        System.debug(' @@ OperatingHours : '+ oh);
        System.debug(' @@ Policy Id : '+ FSP);
        
        List<ESWFieldServiceScheduling.ESWSchedulingParameters> lstESWS =new List<ESWFieldServiceScheduling.ESWSchedulingParameters>();
        ESWFieldServiceScheduling.ESWSchedulingParameters ESWS = new ESWFieldServiceScheduling.ESWSchedulingParameters();
        ESWS.ServiceAppointment = serviceApp;
        ESWS.operatingHoursId=oh.Id;
        ESWS.policyId=FSP.Id;
        ESWS.maxGradeRange = 100;
        ESWS.minGradeRange = 60;
        lstESWS.add(ESWS);
        
        List<ESWFieldServiceScheduling.ResultWrapper> result = ESWFieldServiceScheduling.getSlots(lstESWS);
        ESWFieldServiceSchedWrapper obj = new ESWFieldServiceSchedWrapper();
        System.assert(result!=null);
        
    }
    
}