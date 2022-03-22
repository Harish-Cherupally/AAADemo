@isTest
private class SetLocalTimeOnSA_Test{
  //@testSetup
  static testMethod  void setupTestData(){
    test.startTest();
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
    
    
    ServiceAppointment serviceappointment_Obj = new ServiceAppointment(ParentRecordId = account_Obj.id, 
    EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), SchedStartTime = DateTime.now(), 
    SchedEndTime = DateTime.now(), ActualStartTime = DateTime.now(), ActualEndTime = DateTime.now(), 
    FSL__Auto_Schedule__c = false, FSL__Emergency__c = false, FSL__InJeopardy__c = false, FSL__IsFillInCandidate__c = false,
     FSL__IsMultiDay__c = false, FSL__Pinned__c = false, FSL__Prevent_Geocoding_For_Chatter_Actions__c = false,
      FSL__Same_Day__c = false, FSL__Same_Resource__c = false, FSL__Schedule_over_lower_priority_appointment__c = false, 
      FSL__UpdatedByOptimization__c = false, FSL__Use_Async_Logic__c = false, 
      FSL__Virtual_Service_For_Chatter_Action__c = false, Created_by_Rider__c = false, 
      Self_Schedule_Appt_Confirmed__c = false, In_Scheduler__c = false, local_start__c = 'local413', 
      local_end__c = 'local266',ServiceTerritoryId = stRec.Id);
    Insert serviceappointment_Obj; 
      system.debug(serviceappointment_Obj.SchedStartTime);
      system.debug(serviceappointment_Obj.SchedEndTime);
    
   /* ServiceAppointment serviceappointment_Obj2 = new ServiceAppointment(ParentRecordId = account_Obj.id, 
    EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), SchedStartTime = null, 
    SchedEndTime = null, ActualStartTime = DateTime.now(), ActualEndTime = DateTime.now(), 
    FSL__Auto_Schedule__c = false, FSL__Emergency__c = false, FSL__InJeopardy__c = false, FSL__IsFillInCandidate__c = false,
     FSL__IsMultiDay__c = false, FSL__Pinned__c = false, FSL__Prevent_Geocoding_For_Chatter_Actions__c = false,
      FSL__Same_Day__c = false, FSL__Same_Resource__c = false, FSL__Schedule_over_lower_priority_appointment__c = false, 
      FSL__UpdatedByOptimization__c = false, FSL__Use_Async_Logic__c = false, 
      FSL__Virtual_Service_For_Chatter_Action__c = false, Created_by_Rider__c = false, 
      Self_Schedule_Appt_Confirmed__c = false, In_Scheduler__c = false, local_start__c = 'local413', 
      local_end__c = 'local266',ServiceTerritoryId = stRec.Id);
    Insert serviceappointment_Obj2; */
      
    
    List<ServiceAppointment> ServiceAppRecList = new List<ServiceAppointment>();
    ServiceAppRecList.add(serviceappointment_Obj);
    //ServiceAppRecList.add(serviceappointment_Obj2);
    
    Map<Id,ServiceAppointment> saMap =  new Map<Id,ServiceAppointment>();
    saMap.put(serviceappointment_Obj.id, serviceappointment_Obj);
    System.debug('saMap>>> '+saMap);
    serviceappointment_Obj.SchedStartTime = DateTime.now();
    serviceappointment_Obj.SchedEndTime = system.now();
    update serviceappointment_Obj;
      system.debug(serviceappointment_Obj.SchedStartTime);
      system.debug(serviceappointment_Obj.SchedEndTime);
    ServiceAppRecList.add(serviceappointment_Obj);
      
    //System.assertEquals(true,serviceappointment_Obj.size()>0);
    SetLocalTimeOnSA obj01 = new SetLocalTimeOnSA();
    SetLocalTimeOnSA.setLocalTime(ServiceAppRecList,saMap);
    
    serviceappointment_Obj.SchedStartTime = null;
    serviceappointment_Obj.SchedEndTime = null;
    Update serviceappointment_Obj;
    
    SetLocalTimeOnSA.restrictCreationOfNewSA(ServiceAppRecList);
    
    test.stopTest();
  }
  /*static testMethod void test_setLocalTime_UseCase1(){
    List<ServiceAppointment> serviceappointment_Obj  =  [SELECT Id,AppointmentNumber,ServiceTerritoryId,CreatedDate,
    CreatedById,ParentRecordId,EarliestStartTime,DueDate,SchedStartTime,SchedEndTime,ActualStartTime,
    ActualEndTime,FSL__Auto_Schedule__c,FSL__Emergency__c,FSL__InJeopardy__c,FSL__IsFillInCandidate__c,
    FSL__IsMultiDay__c,FSL__Pinned__c,FSL__Prevent_Geocoding_For_Chatter_Actions__c,FSL__Same_Day__c,
    FSL__Same_Resource__c,FSL__Schedule_over_lower_priority_appointment__c,FSL__UpdatedByOptimization__c,
    FSL__Use_Async_Logic__c,FSL__Virtual_Service_For_Chatter_Action__c,Created_by_Rider__c,Self_Schedule_Appt_Confirmed__c,
    
    In_Scheduler__c,local_start__c,local_end__c from ServiceAppointment];
    
    ServiceAppointment serviceappointment_Obj2 = new ServiceAppointment( 
    EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), SchedStartTime = DateTime.now(), 
    SchedEndTime = DateTime.now(), ActualStartTime = DateTime.now(), ActualEndTime = DateTime.now(), 
    FSL__Auto_Schedule__c = false, FSL__Emergency__c = false, FSL__InJeopardy__c = false, FSL__IsFillInCandidate__c = false,
     FSL__IsMultiDay__c = false, FSL__Pinned__c = false, FSL__Prevent_Geocoding_For_Chatter_Actions__c = false,
      FSL__Same_Day__c = false, FSL__Same_Resource__c = false, FSL__Schedule_over_lower_priority_appointment__c = false, 
      FSL__UpdatedByOptimization__c = false, FSL__Use_Async_Logic__c = false, 
      FSL__Virtual_Service_For_Chatter_Action__c = false, Created_by_Rider__c = false, 
      Self_Schedule_Appt_Confirmed__c = false, In_Scheduler__c = false, local_start__c = 'local413', 
      local_end__c = 'local266');
    Insert serviceappointment_Obj2; 
    
    Map<Id,ServiceAppointment> saMap =  new Map<Id,ServiceAppointment>();
    saMap.put(serviceappointment_Obj2.id, serviceappointment_Obj2);
    System.debug('saMap>>> '+saMap);
    serviceappointment_Obj[0].SchedStartTime = system.today();
    serviceappointment_Obj[0].SchedEndTime = system.today()+1;
    update serviceappointment_Obj;
    
    System.assertEquals(true,serviceappointment_Obj.size()>0);
    SetLocalTimeOnSA obj01 = new SetLocalTimeOnSA();
    SetLocalTimeOnSA.setLocalTime(serviceappointment_Obj,saMap);
  }*/
}