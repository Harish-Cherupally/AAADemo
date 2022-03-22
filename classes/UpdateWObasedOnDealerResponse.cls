/*

* Created By : CR Team
* Cerated Date : 5th march 2022
* Description :This class is developed As per the JIRA sotry A3SHCRSF3-77, A3SHCRSF3-83(Sprint 3 Dealer Email functionality).
Based on cusotmer email response updaing  work order record throguht inbound email service.
* Modified History:
* 
* *******/



global class UpdateWObasedOnDealerResponse implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email2, 
                                                           Messaging.InboundEnvelope env)
    {
        string  className='UpdateWObasedOnDealerResponse';
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
   String myPlainText= '';
         myPlainText = email2.plainTextBody;
        String findwo = myPlainText.substringBetween('#$','#$');
               string  woid = findwo.replaceAll( '\\s+', '');                               
        try {
            WorkOrder  wo= [SELECT id,Assigned_Dealer__c,caseID,WorkOrderNumber,Status,  Dealer_Acknowledged__c  
                            FROM WorkOrder  
                            WHERE WorkOrderNumber =:woid  LIMIT 1];
            System.debug('*****wo***'+wo);
            Contact vCon = [SELECT Id, Name, Email 
                            FROM Contact 
                            WHERE Email = :email2.fromAddress 
                            AND AccountId=:wo.Assigned_Dealer__c   LIMIT 1];
            
            List<String> AcceptTerms= System.Label.AcceptTerms.split(',');
            List<String> RejectTerms= System.Label.RejectTerms.split(',');
            
            /*        if(AcceptTerms!= null || RejectTerms!= null){

if(AcceptTerms.contains(myPlainText.toUppercase())){

System.debug('******if yes***');
wo.Dealer_Acknowledged__c  = true;
} else if(RejectTerms.contains(myPlainText.toUppercase())){

System.debug('******if yes***');
wo.Status='Dealer Rejected';   
}
}

*/
            
            if(myPlainText.containsany('Accept')||myPlainText.contains('Yes') ||
               myPlainText.containsany('interested') ||myPlainText.containsany('yeah') || myPlainText.containsany('yep') ) {
                   
                   System.debug('******if yes***');
                   wo.Dealer_Acknowledged__c  = true;
                   
                   
               }  else if(myPlainText.contains('Reject')||myPlainText.contains('NO') ||myPlainText.containsany('not interested')) {
                   System.debug('******If no***');
                   wo.Status='Dealer Rejected';   
               }
            
            update wo;
            System.debug('*****wo after update***'+wo);
            // Create a new Task object 
            Task[] newTask = new Task[0];
            
            // Add a new Task to the contact record we just found above.
            newTask.add(new Task(Description =  myPlainText,
                                 Priority = 'Normal',
                                 Status = 'Inbound Email',
                                 Subject = email2.subject,
                                 IsReminderSet = true,
                                 whatID=wo.CaseID,
                                 ReminderDateTime = System.now()+1,
                                 WhoId =  vCon.Id));
            
         
            insert newTask;    
         
            
        }
        catch (QueryException e) {
            System.debug('Query Issue: ' + e);
            insert new Error_Log__c(Error_Message__c = e.getMessage(),  Error_Stack_Trace__c = e.getStackTraceString(),
                                    Additional_Info__c = 'Inbound email service funtionality', Custom_Message__c = 'Error in updating WO and cretaion of new task',Source__c = className );
          }
        result.success = true;
        return result;
    }
}