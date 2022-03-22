@isTest
public class WorkOrderTriggerHandler_Test {
    @isTest
    static void restrictChangeAssignedDealer_Test(){
        DateTime dt = system.now();
        
        Contact con = new Contact(); 
        con.LastName = 'Tsting';
        insert con;
        
        WorkOrder wo = new WorkOrder();
        wo.ContactId = con.Id;
        wo.Status = 'New';
        insert wo;
        
        ServiceAppointment sa = new ServiceAppointment();
        //sa.RecordTypeId = '012030000008mdvAAA';
        sa.Status = 'In Progress';        
        sa.ParentRecordId = wo.Id;
        sa.Service_Type__c = 'Training';                
        sa.EarliestStartTime = dt;
        sa.DueDate = dt.addMinutes(10);
        sa.SchedStartTime =dt ;
        sa.SchedEndTime = dt.addMinutes(10);
        sa.Service_Type__c = 'New Installation';
        insert sa; 
        
        WorkOrder woListToUpdate = [SELECT Id,(SELECT Id, Status FROM ServiceAppointments) FROM WorkOrder WHERE Id =:wo.Id limit 1];
        
        Account acc = new Account();
       // acc.RecordTypeId = '012030000008kwvAAA'; 
        acc.Name = 'testAcc';
        insert acc;
        woListToUpdate.Assigned_Dealer__c = acc.Id;
        woListToUpdate.Service_Type__c = 'New Installation';
        
        String saStatus; 
        String errorMessage = 'Assigned Dealer cannot be changed if SA is ';
       // errorMessage += woListToUpdate.ServiceAppointments__r.status;
        for(ServiceAppointment sas : woListToUpdate.ServiceAppointments){
            errorMessage += sas.status;
        }
        Database.SaveResult result = Database.update(woListToUpdate, false);
        System.assertEquals(errorMessage,result.getErrors()[0].getMessage());    //'Assigned Dealer cannot be changed if SA is in Progress'
                
    }
}