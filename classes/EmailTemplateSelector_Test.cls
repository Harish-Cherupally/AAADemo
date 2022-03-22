@isTest
public class EmailTemplateSelector_Test {
    
    static testMethod void getEmailTemplateTest() {
        
        Test.startTest();   
        EmailTemplateSelector.getEmailTemplate('AAA Cancellation Letter');
        Test.stopTest();
        
    }
}