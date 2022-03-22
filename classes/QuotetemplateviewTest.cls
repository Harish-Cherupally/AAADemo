/* JIRA Num :
 * Class Name : Quotetemplateview,QuoteController
 * Refered Component Name : Quote_Preview_and_Send
*/
@isTest
public class QuotetemplateviewTest {
    /*JIRA Num :
     * MethodName :getContactEmail
     * Description : Creating Test Class for the getContactEmail
     * Modification History
    */
    @testsetup static void testData(){
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Account> accList = TestDataFactory.createAccounts(1,fieldDatas,true);
        List<Contact> conList = TestDataFactory.createContact(1,fieldDatas,true);
        for(Contact con :conList){
            con.Email = 'Test@gmail.com';
        }
        Update conList;
        SBQQ__Quote__c quoteObject = new SBQQ__Quote__c
            (SBQQ__PrimaryContact__c = conList[0].Id, SBQQ__Account__c = accList[0].Id ,SBQQ__Status__c = 'Esign Initiated');
        
        Insert quoteObject;
    }
    
    @isTest static void getContactEmailTest(){
        SBQQ__Quote__c sq = [select id from SBQQ__Quote__c limit 1];
        PageReference pageRef = Page.InMaintenance; // Adding VF page Name here
        pageRef.getParameters().put('id', String.valueOf(sq.id));//for page reference
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('RecordType','ExhibitAadminTier');
        ApexPages.StandardController sc = new ApexPages.standardController(sq);
        Quotetemplateview qtt = new Quotetemplateview(sc);
        qtt.GetQuote();//Page Reference method name
    }


    
}