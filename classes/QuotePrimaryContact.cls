/* JIRA Num:
* Class Name:QuotePrimaryContact
* Reffered Comp Name: Quote_Preview_And_Send
*/
public class QuotePrimaryContact {
    /* JIRA Num:
* Method Name:getContactEmail
* @param:recordId
* @return:primary contact email
* Description: geting the value from quot related primary contact email
* Modification History: 
*/
    @AuraEnabled
    public static string getContactEmail (Id recordId){
        List<SBQQ__Quote__c> lstQuote = [SELECT Id, SBQQ__PrimaryContact__c,SBQQ__Status__c,SBQQ__PrimaryContact__r.Email
                                         FROM SBQQ__Quote__c 
                                         WHERE id =:recordId LIMIT 1];
        
        if( lstQuote != null && !( lstQuote[0].SBQQ__Status__c == 'Draft' || 
                                  lstQuote[0].SBQQ__Status__c == 'Presented'|| 
                                  lstQuote[0].SBQQ__Status__c == 'Client Rejected')){
                                      return 'Warning :'+'Quote status should be Draft or Presented. Sending email is not availble for status : '+ lstQuote[0].SBQQ__Status__c;
                                  }else if(lstQuote != null && lstQuote[0].SBQQ__PrimaryContact__r.Email != null)
                                  {
                                      return lstQuote[0].SBQQ__PrimaryContact__r.Email;
                                  }
        return null;
        
    }
    /* JIRA Num:
* Method Name:updateContactEmail
* @param:recordId,sent email
* @return:sucess/Error
* Description: updating the sent email value on quote object.
* Modification History: 
*/
    @AuraEnabled
    public static string updateContactEmail (Id recordId,Boolean isSendEmail){
        try{
            List<SBQQ__Quote__c> lstQuote = [SELECT Id, Sent_Email__c,SBQQ__PrimaryContact__c
                                             FROM SBQQ__Quote__c
                                             WHERE id =:recordId
                                             LIMIT 1];
            
            if(lstQuote != null)
            {  
                lstQuote[0].Sent_Email__c = isSendEmail;
                update lstQuote; 
            }
        }catch(Exception ex)
        {
            insert new Error_Log__c(Source__c = 'QuotePrimaryContact-updateContactEmail',
                                    Error_Message__c = ex.getMessage(),
                                    Error_Stack_Trace__c = ex.getStackTraceString(),
                                    Custom_Message__c = 'Exception thrown while updating sent email',
                                    Additional_Info__c = 'quoteId and Sent Email');
            throw new AuraHandledException(ex.getMessage());
        }
        return 'Sucess';
    }
}