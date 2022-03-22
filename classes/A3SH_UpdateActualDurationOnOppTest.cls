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
private class A3SH_UpdateActualDurationOnOppTest {

    /***************************************************************
     * Test Method for updating the actual duration on oppty
     * *************************************************************/
    @isTest static void updateActualDurationOnOpp() {
        Contact conObj = new Contact(FirstName = 'test', LastName = 'Test',phone='1234567890');
        Database.insert(conObj);
        Opportunity oppObj = new Opportunity(accountId = conObj.AccountId, Name = 'Test Opportunity', StageName='Quote',CloseDate = System.today());
        Database.insert(oppObj);
        oppObj.StageName='Closed Won';
        Database.update(oppObj);
        WorkOrder woObj = new WorkOrder(AccountId = conObj.AccountId,contactId = conObj.Id, opportunity__c = oppObj.Id,Status = 'New',Service_Type__c = 'New Installation');
        Database.insert(woObj);
        List<ServiceAppointment> serviceAppointmentList = null;
        Test.startTest();
        ServiceAppointment saObj = new ServiceAppointment(ParentRecordId = woObj.Id, contactId = conObj.Id,Opportunity__c = oppObj.Id,Status='None',Service_Type__c = 'New Installation',
                                                         ActualStartTime = DateTime.now(), ActualEndTime = DateTime.now()+1);
        Database.insert(saObj);
        
        A3SH_EncryptSAID.EncryptData encryptData = new A3SH_EncryptSAID.EncryptData();
        encryptData.serviceAppointmentId = saObj.Id;
        List<A3SH_EncryptSAID.EncryptData> encryptDataList = new List<A3SH_EncryptSAID.EncryptData>{encryptData};
        A3SH_EncryptSAID.encryptSAID(encryptDataList);
        
        
        FSL.GlobalAPIS.addStatusTransition('None', 'Completed');
        saObj.Service_Type__c = 'New Installation';
        saObj.Status = 'Completed';
        saObj.Billable__c = 'Billable';
        saObj.Resolution_Code__c = '_Completed'; 
        saObj.ServiceNote = 'testing';
        Database.update(saObj);
        List<String> saIds = new List<String>{saObj.Id};
        serviceAppointmentList = [Select Id,Opportunity__c from ServiceAppointment Where Service_Type__c='New Installation' AND 
                                                           Opportunity__c != null AND ID IN :saIds AND Status= 'Completed'];
        A3SH_UpdateActualDurationFromSA.updatActualDurationOnOpptyFromSA(saIds);
        Test.stopTest(); 
        System.assert(serviceAppointmentList != null);
    }
}