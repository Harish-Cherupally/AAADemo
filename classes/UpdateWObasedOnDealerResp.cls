global class UpdateWObasedOnDealerResp implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email1, 
                                                           Messaging.InboundEnvelope env)
    {
        
        // Create an InboundEmailResult object for returning the result of the 
        // Apex Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String myPlainText= '';
        // Add the email plain text into the local variable 
        myPlainText = email1.plainTextBody;
        System.debug('******myPlainText***'+myPlainText);
        // string findwo= myPlainText.substringAfter('#$@');
        String findwo = myPlainText.substringBetween('#$','#$');
        system.debug('***findwo***'+findwo);  
        string  woid = findwo.replaceAll( '\\s+', '');                               
        system.debug('***woid***'+woid);                                                      
        
        
        try {
            WorkOrder  wo= [SELECT id,Assigned_Dealer__c,Customer_Acknowledged__c,contactId,WorkOrderNumber,Status,AccountId,  Dealer_Acknowledged__c  
                            FROM WorkOrder  
                            WHERE WorkOrderNumber =:woid  LIMIT 1];
            
            
            List<String> AcceptTerms= System.Label.AcceptTerms.split(',');
            List<String> RejectTerms= System.Label.RejectTerms.split(',');
            
            if(AcceptTerms!= null || RejectTerms!= null){
                
                if(AcceptTerms.contains(myPlainText.toUppercase())){
                    
                     System.debug('******if yes***');
                wo.Customer_Acknowledged__c=True;
                } else if(RejectTerms.contains(myPlainText.toUppercase())){
                    
                   System.debug('******If no***');
                wo.Status='Customer Reject';   
                }
            }
            
        /*    if(myPlainText.containsany('Accept')||myPlainText.contains('Yes') ) {
                System.debug('******if yes***');
                wo.Customer_Acknowledged__c=True;
                
            } else if(myPlainText.contains('Reject')||myPlainText.contains('NO')) {
                System.debug('******If no***');
                wo.Status='Customer Reject';   
            }
          */  
            update wo;
            
            System.debug('*****wo after update***'+wo);         
            // Create a new Task object 
            Task[] newTask = new Task[0];
            
            // Add a new Task to the contact record we just found above.
            newTask.add(new Task(Description =  myPlainText,
                                 Priority = 'Normal',
                                 Status = 'Inbound Email',
                                 Subject = email1.subject,
                                 IsReminderSet = true,
                                 whatID=wo.id,
                                 ReminderDateTime = System.now()+1,
                                 WhoId =  Wo.contactId));
            
            // Insert the new Task 
            insert newTask;    
            system.debug('***newTask***'+newTask);  
            
        }
        catch (QueryException e) {
            System.debug('Query Issue: ' + e);
        }
        // Set the result to true. No need to send an email back to the user 
        // with an error message
        result.success = true;
        // Return the result for the Apex Email Service
        return result;

    }
}