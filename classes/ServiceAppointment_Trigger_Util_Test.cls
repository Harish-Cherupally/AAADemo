@isTest
public class ServiceAppointment_Trigger_Util_Test {  
    @isTest
    static void test_validate_SACreation(){ 
        Id woId = TestDataFactory.createWorkOrder(1,null,true)[0].Id;
        
        Account account_Obj= new Account ();
        account_Obj.Name = 'TestAcc';
        insert account_Obj;
        
        Contact contact_Obj = new Contact();
        contact_Obj.AccountId = account_Obj.Id;
        contact_Obj.LastName = 'TestCon';
        contact_Obj.Email = 'santhosh.vaaraala@criticalriver.com';
        insert contact_Obj;
        
        OperatingHours ohRec= new OperatingHours();
        ohRec.Name = 'test operting hours';
        insert ohRec;
        
        ServiceTerritory stRec= new ServiceTerritory();
        stRec.OperatingHoursId = ohRec.Id;
        stRec.Name = 'Test territory'; 
        stRec.IsActive = true;
        insert stRec;
        
        ServiceAppointment createSA = new ServiceAppointment(ParentRecordId = woId, 
                                                             EarliestStartTime = DateTime.now(),
                                                             DueDate = DateTime.now(),
                                                             SchedStartTime = DateTime.now(),
                                                             SchedEndTime = DateTime.now(), 
                                                             ServiceTerritoryId = stRec.Id,
                                                             Service_Type__c = 'New Installation',
                                                             Status = 'None',
                                                             //AccountId = account_Obj.Id,
                                                             ContactId = contact_Obj.Id);
        insert createSA;        
        List<Service_Appointment_Snapshot__c>  SASnapshot= [SELECT Id FROM Service_Appointment_Snapshot__c WHERE 
                                                            Service_Appointment__c =: createSA.Id];
        System.assertEquals(1, SASnapshot.Size());
    }
    
    @isTest
    static void test_validate_SACreationBulk(){ 
        // Id woId = TestDataFactory.createWorkOrder(1,null,true)[0].Id;
        List<WorkOrder> woIds = TestDataFactory.createWorkOrder(10,null,true);
        
        OperatingHours ohRec= new OperatingHours();
        ohRec.Name = 'test operting hours';
        insert ohRec;
        
        ServiceTerritory stRec= new ServiceTerritory();
        stRec.OperatingHoursId = ohRec.Id;
        stRec.Name = 'Test territory';
        stRec.IsActive = true;
        insert stRec;
        
        List<ServiceAppointment> createSAs = new List<ServiceAppointment>();
        for(WorkOrder wo: woIds){
            ServiceAppointment createSA = New ServiceAppointment();
            createSA.ParentRecordId = wo.Id;
            createSA.EarliestStartTime = DateTime.now();
            createSA.DueDate = DateTime.now();
            createSA.SchedStartTime = DateTime.now();
            createSA.SchedEndTime = DateTime.now();
            createSA.ServiceTerritoryId = stRec.Id;
            createSA.Service_Type__c = 'New Installation';
            createSA.Status = 'None';
            createSAs.add(createSA);
        }
        insert createSAs;  
        List<Id> createSAIds = new List<Id>();
        for(ServiceAppointment tempSA : createSAs){
            createSAIds.add(tempSA.Id);
        }
        System.debug(createSAs);
        List<Service_Appointment_Snapshot__c>  SASnapshot= [SELECT Id FROM Service_Appointment_Snapshot__c WHERE 
                                                            Service_Appointment__c IN : createSAs];
        System.assertEquals(10, SASnapshot.Size());
    }
    
    @isTest
    static void test_validate_SAUpdation(){                             
        Id woId = TestDataFactory.createWorkOrder(1,null,true)[0].Id;
        List<WorkOrder> woIds = TestDataFactory.createWorkOrder(10,null,true);
        System.debug(woIds);
        
        Account account_Obj= new Account ();
        account_Obj.Name = 'TestAcc';
        insert account_Obj;
        
        Contact contact_Obj = new Contact();
        contact_Obj.AccountId = account_Obj.Id;
        contact_Obj.LastName = 'TestCon';
        contact_Obj.Email = 'santhosh.vaaraala@criticalriver.com';
        insert contact_Obj;
        
        OperatingHours ohRec = new OperatingHours();
        ohRec.Name = 'test operting hours';
        insert ohRec;
        
        ServiceTerritory stRec = new ServiceTerritory();
        stRec.OperatingHoursId = ohRec.Id;
        stRec.Name = 'Test territory';
        stRec.IsActive = true;
        insert stRec;
        List<ServiceAppointment> saListUpdated = new List<ServiceAppointment>();
        Map<Id,ServiceAppointment> oldMap = new Map<Id, ServiceAppointment>(); 
        
        ServiceAppointment createSA = new ServiceAppointment(ParentRecordId = woId, 
                                                             EarliestStartTime = DateTime.now(),
                                                             DueDate = DateTime.now().addDays(2),
                                                             SchedStartTime = DateTime.now(),
                                                             SchedEndTime = DateTime.now(), 
                                                             ServiceTerritoryId = stRec.Id,
                                                             Service_Type__c = 'New Installation',
                                                             Status = 'None',
                                                             ContactId = contact_Obj.Id
                                                             );
        insert createSA;
        //oldMap.put(createSA.id, createSA);
        List<Service_Appointment_Snapshot__c> saSnapshot1 = [SELECT Id,Status__c FROM Service_Appointment_Snapshot__c WHERE
                                                            Service_Appointment__c =: createSA.Id];   
             
        System.assertEquals(1,saSnapshot1.size());
                
        createSA.SchedStartTime = DateTime.now().addHours(1);
        createSA.SchedEndTime = DateTime.now().addHours(2);
        createSA.Status = 'Scheduled';
        createSA.Self_Scheduled__c = true;
        update createSA;        
        
        List<Service_Appointment_Snapshot__c> saSnapshot2 = [SELECT Id, Status__c FROM Service_Appointment_Snapshot__c WHERE
                                                            Service_Appointment__c =: createSA.Id]; 
        
        System.assertEquals(2,saSnapshot2.size());       
    }
    
    @isTest
    static void test_validate_SAUpdationBulk(){         
        List<WorkOrder> woIds = TestDataFactory.createWorkOrder(10,null,true);
        
        OperatingHours ohRec= new OperatingHours();
        ohRec.Name = 'test operting hours';
        insert ohRec;
        
        ServiceTerritory stRec= new ServiceTerritory();
        stRec.OperatingHoursId = ohRec.Id;
        stRec.Name = 'Test territory';
        stRec.IsActive = true;
        insert stRec;
        
        List<ServiceAppointment> createSAs = new List<ServiceAppointment>();
        for(WorkOrder wo :  woIds){
            ServiceAppointment createSA = New ServiceAppointment();
            createSA.ParentRecordId = wo.Id;
            createSA.EarliestStartTime = DateTime.now(); 
            createSA.DueDate = DateTime.now();
            createSA.SchedStartTime = DateTime.now();
            createSA.SchedEndTime = DateTime.now() + 10;
            createSA.ServiceTerritoryId = stRec.Id;
            createSA.Service_Type__c = 'New Installation';
            createSA.Status = 'None';
            createSAs.add(createSA);
        }
        insert createSAs;
        
        List<Id> createSAIds = new List<Id>();
        for(ServiceAppointment tempSA : createSAs){
            tempSA.SchedStartTime = DateTime.now() + 5;
            createSAIds.add(tempSA.Id);
        }
        update createSAs;
        List<Service_Appointment_Snapshot__c>  SASnapshot= [SELECT Id FROM Service_Appointment_Snapshot__c WHERE 
                                                            Service_Appointment__c IN : createSAIds];
        System.assertEquals(20, SASnapshot.Size());
    }
}