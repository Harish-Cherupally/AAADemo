/*******
* Created By : CR Team
* Cerated Date : 1 st  Feb 2022
* Description :As per the JIRA sotry A3SHCRSF3-34  need to mofify the exisiting parent accounnt to populate the 
* no of site account.
*   Need to run this batch one time
* Modified History:
* 
* *******/
global class CountNumberOfSiteAccount implements Database.Batchable<SObject>{
    private static String className = 'CountNumberOfSiteAccount';
    private static String methodName;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select Id,Name,No_Of_Site_Accounts__c,ParentId  FROM Account WHERE ParentId = null  AND Parent_Account__c = true]);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> parentAccs){
        methodName = 'execute';        
        try{
            List<Account> accountsToUpdate = new List<Account>();
            Map<Id,Account> accDetailMap = new Map<Id,Account>(parentAccs);
            List<Error_Log__c> errsStaging = new List<Error_Log__c>();
            
            for (AggregateResult ar : [SELECT COUNT(ID), ParentID FROM Account 
                                       WHERE ParentID IN :accDetailMap.keySet()
                                       AND RecordType.Name = 'SiteAccount'
                                       GROUP BY ParentID]){
                                           
            	Id accID = (ID)ar.get('ParentID');
                Integer count = (Integer)ar.get('expr0');
                Account tempAcc = new Account(Id=accID);
                tempAcc.No_Of_Site_Accounts__c = count;
                accountsToUpdate.add(tempAcc);                          
            }
            
            if(!accountsToUpdate.isEmpty()){ 
                Database.SaveResult[] updateResults = Database.update(accountsToUpdate, false);
                                
                for(Integer i=0;i<updateResults.size();i++){
                    if (updateResults.get(i).isSuccess()){
                        updateResults.get(i).getId();                    
                    } else if(!updateResults.get(i).isSuccess()){
                        errsStaging.add(new Error_Log__c(
                            Source__c= className + ' ' + methodName, 
                            Error_Message__c=updateResults.get(i).getErrors().get(0).getMessage(),
                            Custom_Message__c = 'Exception thrown while updating Parent Account with Count of Site Accounts',
                            Additional_Info__c = accountsToUpdate.get(i).Id));
                    }                
                }
            }
                
            if(errsStaging.size() > 0){insert errsStaging;}                              
        }
        catch(Exception ex){
            insert new Error_Log__c(Source__c = className + ' ' + methodName,
                                    Error_Message__c = ex.getMessage(),
                                    Error_Stack_Trace__c = ex.getStackTraceString(),
                                    Custom_Message__c = 'Upating Parent Account based on Child Site Accounts count',
                                    Additional_Info__c = JSON.serialize(parentAccs));
            throw ex;
        }        
    }
    
    global void finish(Database.BatchableContext bc){        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Use the
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
                          a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                          a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        
        // below code will send an email to User about the status
        String[] email = new String[]{'suman.venuvanka@criticalriver.com'};
        mail.setToAddresses(email);
        mail.setReplyTo('suman.venuvanka@criticalriver.com'); // Add here your email address
        mail.setSenderDisplayName('Apex Batch Processing Module');
        mail.setSubject('Batch Processing '+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed '+ a.TotalJobItems+'batches with '+a.NumberOfErrors+'failures '+'Job Itemprocessed are '+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
    }    
}