/*******************************************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/31/2021
* @Description   : This apex class is test class for A3SH_SendSMSUsingTwillioAPI
*********************************************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
***************************************************************************************************************************
1. 
*******************************************************************************************************************************/
@isTest
private class A3SH_SendSMSUsingTwillioTest {
    /***************************************************************
     * Test Method for task creation and send SMS
     * *************************************************************/
    @isTest static void testSendSMS() {
        Contact conObj = new Contact(FirstName = 'test', LastName = 'Test',phone='1234567890');
        Database.insert(conObj);
        Opportunity oppObj = new Opportunity(accountId = conObj.AccountId, Name = 'Test Opportunity', StageName='Quote',CloseDate = System.today());
        Database.insert(oppObj);
        oppObj.StageName='Closed Won';
        Database.update(oppObj);
        WorkOrder woObj = new WorkOrder(AccountId = conObj.AccountId,contactId = conObj.Id, opportunity__c = oppObj.Id,Status = 'New',Service_Type__c = 'New Installation');
        Database.insert(woObj);
        ServiceAppointment saObj = new ServiceAppointment(ParentRecordId = woObj.Id, contactId = conObj.Id,Opportunity__c = oppObj.Id);
        Database.insert(saObj);
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new A3SH_SendSMSUsingTwillioMockAuth());
        
        Test.startTest();
        Task taskObj = new Task(whatId = saObj.Id,subject='Sent AAA 2 Day Appointment Reminder Email');
        Database.insert(taskObj);
        Test.stopTest(); 
    }
}