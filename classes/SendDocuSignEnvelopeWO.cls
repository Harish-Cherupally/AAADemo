public class SendDocuSignEnvelopeWO {
    /*
Created By  : CR Team
Created Date :24 jan 2022
Description: *****************
JIRA Sotry :
Modification Histrory:
*/
    /* This method is invoked from Update status of Opp_WO_Case_Based on SA flow .
     * When Service Appointment is Completed
     * Passing Workorders IDs
 */
 @InvocableMethod
    public static void sendDocuSignEnvelopeWO(List<Id> ids){
             try{
      List<WorkOrder> WODetails = new List<WorkOrder>([SELECT Id, OwnerId, contactID,status,contact.Email,contact.Name,IsDeleted, WorkOrderNumber
                                                            FROM WorkOrder
                                                            WHERE Id  IN: ids]);
            
            if(WODetails.size() > 0){
             String envelopeTemplateName='Work Order RIC';
              //  ; = WODetails[0].Is_Finance__c == true ? (quoteDetails[0].Organization__c == 'AAA' ? 'AAA with Finance' : 'A3 with Finance') : (quoteDetails[0].Organization__c == 'AAA' ? 'AAA without Finance' : 'A3 without Finance');                                
                
                if(envelopeTemplateName != null){
                	List<dfsle__EnvelopeConfiguration__c> templateDetails = new List<dfsle__EnvelopeConfiguration__c>([SELECT Id,Name,dfsle__DocuSignId__c 
                                                                                                                       FROM dfsle__EnvelopeConfiguration__c 
                                                                                                                       WHERE Name =:envelopeTemplateName]);
                    if(templateDetails.size() > 0){
                        // Create an empty envelope.
						dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(WODetails[0].id)); // The initiating Salesforce entity.
                                                
                        //use the Recipient.fromSource method to create the Recipient
                        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
                                    WODetails[0].Contact.Name, // Recipient name
                                    WODetails[0].Contact.Email, // Recipient email
                                    null, //Optional phone number
                                    'Member', //Role Name. Specify the exact role name from template
                                    new dfsle.Entity(WODetails[0].contactID)); //source object for the Recipient
                        
                        //add Recipient to the Envelope
                        myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
                       
                        //myTemplateId contains the DocuSign Id of the DocuSign Template
                        dfsle.UUID myTemplateId = dfsle.UUID.parse(templateDetails[0].dfsle__DocuSignId__c);
                        
                        //create a new document for the Envelope
                        dfsle.Document myDocument = dfsle.Document.fromTemplate(
                            myTemplateId, // templateId in dfsle.UUID format
                            templateDetails[0].Name); // name of the template
                        
                        //add document to the Envelope
                        myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });
                        
                        // Send the envelope.
                        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
                            myEnvelope, // The envelope to send
                            true); // Send now?
                        //ESign
                        //Update quote status to Esign Initiated
                        WODetails[0].status = 'Esign Initiate';
                        update WODetails[0];
                    }
                }            	    
            }            			
     }
        catch(Exception e){
        }    
    }
   /*******************
     @InvocableMethod
    public static void findObjectAPIName(List<Id> recordId){ 
        if(recordId[0] == null)
            return null;
        String objectAPIName = '';
        keyPrefix = recordId[0].substring(0,3);
         for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ){
              String prefix = obj.getDescribe().getKeyPrefix();
               if(prefix == keyPrefix){
                         objectAPIName = obj.getDescribe().getName();
                          break;
                }
         }

        // return objectAPIName;

		}*/
    
            public string findObjectAPIName( String recordId ){
        if(recordId == null)
            return null;
        String objectAPIName = '';
       string keyPrefix = recordId.substring(0,3);
         for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ){
              String prefix = obj.getDescribe().getKeyPrefix();
               if(prefix == keyPrefix){
                         objectAPIName = obj.getDescribe().getName();
                          break;
                }
         }

         return objectAPIName;

}
    }