/* JIRA Num :
 * Class Name : QuotePrimaryContact
 * Refered Component Name : 
*/
@isTest
public class QuotePrimaryContactTest {
    /*JIRA Num :
     * MethodName :updateContactEmail and getContactEmailT
     * Description : creating multiple method for handling different condition init Method
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
        SBQQ__Quote__c SQ = [select id,SBQQ__Status__c, SBQQ__PrimaryContact__c from SBQQ__Quote__c limit 1];
        QuotePrimaryContact.getContactEmail(SQ.Id);
        list<Account> Acc = [select id from Account];
        //QuotePrimaryContact.getContactEmail('test');
    }
    @isTest static void updateContactEmailTest(){
        SBQQ__Quote__c SQ = [select id,SBQQ__Status__c, SBQQ__PrimaryContact__c from SBQQ__Quote__c limit 1];
        QuotePrimaryContact.updateContactEmail(SQ.Id,true);
        Test.startTest();
        try{
        QuotePrimaryContact.updateContactEmail(null,true);
        }catch(Exception e){
            system.debug(e);
        }
        Test.stopTest();
        list<Account> Acc = [select id from Account];

    }
    
}