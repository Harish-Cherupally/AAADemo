/*******************************************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/31/2021
* @Description   : This apex class is test class for A3SH_CovidEmailResponseController
*********************************************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
***************************************************************************************************************************
1. 
*******************************************************************************************************************************/
@isTest
private class A3SH_CovidEmailResponseControllerTest {

    /***************************************************************
     * Test Method for covid email response controller test
     * *************************************************************/
    @isTest static void covidEmailResponseCntrlTest() {
        Contact conObj = new Contact(FirstName = 'test', LastName = 'Test',phone='1234567890');
        Database.insert(conObj);
        Opportunity oppObj = new Opportunity(accountId = conObj.AccountId, Name = 'Test Opportunity', StageName='Quote',CloseDate = System.today());
        Database.insert(oppObj);
        oppObj.StageName='Closed Won';
        Database.update(oppObj);
        WorkOrder woObj = new WorkOrder(AccountId = conObj.AccountId,contactId = conObj.Id, opportunity__c = oppObj.Id,Status = 'New',Service_Type__c = 'New Installation');
        Database.insert(woObj);
        ServiceAppointment saRec = null;
        Test.startTest();
        ServiceAppointment saObj = new ServiceAppointment(ParentRecordId = woObj.Id, contactId = conObj.Id,Opportunity__c = oppObj.Id,Status='None',Service_Type__c = 'New Installation');
        Database.insert(saObj);
        
        A3SH_EncryptSAID.EncryptData encryptData = new A3SH_EncryptSAID.EncryptData();
        encryptData.serviceAppointmentId = saObj.Id;
        List<A3SH_EncryptSAID.EncryptData> encryptDataList = new List<A3SH_EncryptSAID.EncryptData>{encryptData};
        A3SH_EncryptSAID.encryptSAID(encryptDataList);
		
        saRec = [Select Id,Tech_Encrypted_Id__c from ServiceAppointment where Id=:saObj.Id limit 1];
        PageReference pageRef = Page.A3SH_CovidEmailResponse; 
        pageRef.getParameters().put('saId', String.valueOf(saRec.Tech_Encrypted_Id__c));
        Test.setCurrentPage(pageRef);
		A3SH_CovidEmailResponseController covidEmailContrl = new A3SH_CovidEmailResponseController(); 
        covidEmailContrl.getItems();
        covidEmailContrl.submitDetails();
        covidEmailContrl.selectedValue = 'Yes';
        covidEmailContrl.updateSelectedValue();
        covidEmailContrl.submitDetails();
        covidEmailContrl.selectedValue = 'No';
        covidEmailContrl.updateSelectedValue();
        covidEmailContrl.submitDetails();
        Test.stopTest(); 
        System.assert(saRec != null);
        System.assert(!saRec.Tech_Encrypted_Id__c.startsWIth('08p'));
    }
}