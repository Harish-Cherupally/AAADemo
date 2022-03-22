/* JIRA Num :
 * Class Name : ControllerFeedback
 * Refered Component Name : 
*/
@isTest
public class ControllerFeedbackTest {
    /*JIRA Num :
     * MethodName :init and Submit
     * Description : creating multiple method for handling different condition init Method
     * Modification History
    */
    @testsetup static void testData(){
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Account> accList = TestDataFactory.createAccounts(1,fieldDatas,true);
        for(Account acc :accList){
            acc.Name = 'Test';
            acc.Organization__c = 'A3';
            
        }
        Update accList;
        
        List<Contact> conList = TestDataFactory.createContact(1,fieldDatas,true);
        for(Contact con :conList){
            con.Email = 'Test@gmail.com';
            con.lastName = 'Test@gmail.com';
            
        }
        Update conList;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            phone = '9987654331',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c
            (SBQQ__PrimaryContact__c = conList[0].Id, SBQQ__Account__c = accList[0].Id ,
             SBQQ__Status__c = 'Esign Initiated',  Equipment_Down_Payment_Amount__c =10,
             Monthly_Monitoring_Amount__c = 10, Status_Update__c = false,
             SBQQ__SalesRep__c = u.id
            );
        
        Insert quoteObject;   
        
    }
    
    @isTest static void init(){
        SBQQ__Quote__c sq = [select id from SBQQ__Quote__c limit 1];
        PageReference pageRef = Page.InMaintenance; // Adding VF page Name here
        pageRef.getParameters().put('id', String.valueOf(sq.id));//for page reference
        pageRef.getParameters().put('status', 'AcceptWithFull');//for page reference
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('RecordType','ExhibitAadminTier');
        ApexPages.StandardController sc = new ApexPages.standardController(sq);
        ControllerFeedback qtt = new ControllerFeedback();
        qtt.init();//Page Reference method name
        qtt.submit();//Page Reference method name
    }
    @isTest static void init2(){
        SBQQ__Quote__c sq = [select id from SBQQ__Quote__c limit 1];
        PageReference pageRef = Page.InMaintenance; // Adding VF page Name here
        pageRef.getParameters().put('id', String.valueOf(sq.id));//for page reference
        pageRef.getParameters().put('status', 'AcceptWithFinance');//for page reference
        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('RecordType','ExhibitAadminTier');
        ApexPages.StandardController sc = new ApexPages.standardController(sq);
        ControllerFeedback qtt = new ControllerFeedback();
        qtt.init();//Page Reference method name
        qtt.submit();//Page Reference method name
    }
    @isTest static void submitTest(){
        SBQQ__Quote__c sq = [select id from SBQQ__Quote__c limit 1];
        PageReference pageRef = Page.InMaintenance; // Adding VF page Name here
        pageRef.getParameters().put('id', String.valueOf(sq.id));//for page reference
        pageRef.getParameters().put('status', 'Rejected');//for page reference
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('RecordType','ExhibitAadminTier');
        ApexPages.StandardController sc = new ApexPages.standardController(sq);
        ControllerFeedback qtt = new ControllerFeedback();
        qtt.init();//Page Reference method name
        qtt.submit();//Page Reference method name
    }
    
}