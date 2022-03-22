@isTest(SeeAllData=true)
public class ServiceReportTriggerHandlerTest {

    static testMethod void CheckValidRecord() {
        // Create Account
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        // Create Contact
        Contact con = new Contact(FirstName='Face',LastName='Hugger',email='facehugger@alien.com',MobilePhone='07777777777');
        con.AccountId = acc.Id;
        insert con;
        
        // Create Case
        Id csrt = [SELECT Id FROM RecordType WHERE DeveloperName = 'Reputation_Response' AND SobjectType = 'Case' LIMIT 1].Id;
        Case cs = new Case(Subject='Test Case',RecordTypeId=csrt,AccountId=acc.Id,ContactId=con.Id);
        insert cs;
        
        // Create Work Order
        WorkType wt = new WorkType(DurationType='Minutes',EstimatedDuration=35,FSL__Due_Date_Offset__c=4320,Name='Test');
        insert wt;
        
        WorkOrder wo = new WorkOrder(WorkTypeId=wt.Id, ContactId = con.Id, status= 'New');
        insert wo;
        
        // Create Service Appointment
        Date d = System.today();
        DateTime dts = datetime.newInstance(d, Time.newInstance(08,00,00,00));
        DateTime dte = dts.addHours(1);
        ServiceAppointment sa = new ServiceAppointment(ParentRecordId=wo.Id,Status='None',ContactId=con.Id,EarliestStartTime=dts,SchedStartTime=dte,DueDate=dts,SchedEndTime=dte, Service_Type__c = 'New Installation');
        insert sa;
        
        ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentVersion> documents = [SELECT Id, Title, ContentDocumentId FROM ContentVersion where Id=:contentVersion.Id];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = sa.id;
        cdl.ContentDocumentId = documents[0].ContentDocumentId;
        cdl.shareType = 'V';
        insert cdl;
        
        // Create service report
        ServiceReport sr = new ServiceReport();        
        sr.DocumentBody = Blob.valueOf('Test Content') ;
        sr.DocumentContentType ='application/pdf';
        sr.DocumentName='Test';
        sr.ParentId = sa.Id;  
        sr.IsSigned = True;     
        
        insert sr;
        
        system.debug('@@@@'+[select Id, ContentVersionDocumentId From ServiceReport where Id=:sr.Id]);
  }
}