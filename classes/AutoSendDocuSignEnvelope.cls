//This class will generate and sends Docusign Envelope Template using Docusign Apex Toolkit
public class AutoSendDocuSignEnvelope {
    
    private static String className = 'AutoSendDocuSignEnvelope';
    private static String methodName;
    //This will retrieve all the envelope templates created.
    private static Map<String,dfsle__EnvelopeConfiguration__c> envelopeTemplates {get{
        Map<String,dfsle__EnvelopeConfiguration__c> tempData = new Map<String,dfsle__EnvelopeConfiguration__c>();
        for(dfsle__EnvelopeConfiguration__c tempEnvelope :[SELECT Id,Name,dfsle__DocuSignId__c 
                                                           FROM dfsle__EnvelopeConfiguration__c]){
            tempData.put(tempEnvelope.Name,tempEnvelope);
        }
        return tempData; 
    } set;}
    
    /* A3SHCRSF3-10
     * Method Name: sendDocuSignEnvelope
     * Params: SobjectIds: Ids for which Docusign need to be generated and send
     * Description: This method will retrieve Docusign Envelope template based on SObject Data and will generate
					and send to its related Contact.
     */
    public static void sendDocuSignEnvelope(List<Id> sObjectIds){
        methodName = 'sendDocuSignEnvelope';
        try{
            if(sObjectIds != null && sObjectIds.size() > 0){
                String sObjectName = GlobalUtil.getSObjectName(sObjectIds);
                
                /*if(sObjectName == 'SBQQ__Quote__c'){
                
                    List<SBQQ__Quote__c> updateQuoteDetails = new List<SBQQ__Quote__c>();
                    
                    for(SBQQ__Quote__c tempQuote :[SELECT Id,Is_Finance__c,Organization__c,SBQQ__PrimaryContact__c,SBQQ__PrimaryContact__r.Name,SBQQ__PrimaryContact__r.Email
                                                   FROM SBQQ__Quote__c 
                                                   WHERE Id IN :sObjectIds
                                                  	 AND SBQQ__PrimaryContact__c != null]){
                        
                        String envelopeTemplateName = tempQuote.Is_Finance__c == true ? (tempQuote.Organization__c == 'AAA' ? 'AAA with Finance' : 'A3 with Finance') : (tempQuote.Organization__c == 'AAA' ? 'AAA without Finance' : 'A3 without Finance');
                        
                    	generateAndSendDocuSign(envelopeTemplateName,tempQuote.SBQQ__PrimaryContact__r.Name,tempQuote.SBQQ__PrimaryContact__r.Email,tempQuote.SBQQ__PrimaryContact__c,tempQuote.Id);
                        tempQuote.SBQQ__Status__c = 'Esign Initiated';
                        updateQuoteDetails.add(tempQuote);
                    }
                    
                    //Update quote status to Esign Initiated
                    if(updateQuoteDetails.size() > 0){
                        Database.update(updateQuoteDetails,false);
                    }
                }
                else*/ if(sObjectName == 'WorkOrder'){
                    List<WorkOrder> updateWODetails = new List<WorkOrder>();
                    
                    for(WorkOrder tempWO :[SELECT Id,ContactId,Contact.Name,Contact.Email 
                                           FROM WorkOrder 
                                           WHERE ID IN :sObjectIds
                                          	 AND ContactId != null]){
                        //Docusign will generate and send Individually                          
                        generateAndSendDocuSign('Work Order RIC',tempWO.Contact.Name,tempWO.Contact.Email,tempWO.ContactId,tempWO.Id);
                        tempWO.Status = 'Esign Initiated';
                        updateWODetails.add(tempWO);
                    }
                    
                    //Update Work Order status to Esign Initiated
                    if(updateWODetails.size() > 0){
                        Database.update(updateWODetails,false);
                    }
                }                                
            }  
        }
        catch(Exception e){
            insert new Error_Log__c(Error_Message__c = e.getMessage(),Error_Stack_Trace__c = e.getStackTraceString(),Additional_Info__c = JSON.serialize(sObjectIds),
                                    Custom_Message__c = 'Error while sending Docusign Template',Source__c = className + '-' + methodName);
        }      
    }
    
     /* A3SHCRSF3-10
     * Method Name:  generateAndSendDocuSign
     * Params: envelopeTemplateName : This is the Docusign Envelope Template Name
     * 		   contactName : This is the contact email to whom Docusign is to be send
     * 		   contactEmail : This is the contact email to whom Docusign is to be send
     * 		   contactId : This will store the Id of the Contact
     * 		   sObjectId : This is SObjectId for which Docusign need to be generated     
     * Description: This will generate Docusign based on Envelope template and the related SObjectId and later
					sends to the Contact.
     */
    private static void generateAndSendDocuSign(String envelopeTemplateName,String contactName,String contactEmail,Id contactId,Id sObjectId){                  
        if(envelopeTemplateName != null && envelopeTemplates != null && envelopeTemplates.size() > 0 && envelopeTemplates.containsKey(envelopeTemplateName)){
            dfsle__EnvelopeConfiguration__c envelopeData = envelopeTemplates.get(envelopeTemplateName);
            
            // Create an empty envelope.
            dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(sObjectId)); // The initiating Salesforce entity.
            
            //use the Recipient.fromSource method to create the Recipient
            dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
                contactName, // Recipient name
                contactEmail, // Recipient email
                null, //Optional phone number
                'Signer 1', //Role Name. Specify the exact role name from template
                new dfsle.Entity(contactId)); //source object for the Recipient
            
            //add Recipient to the Envelope
            myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
            
            //myTemplateId contains the DocuSign Id of the DocuSign Template
            dfsle.UUID myTemplateId = dfsle.UUID.parse(envelopeData.dfsle__DocuSignId__c);
            
            //create a new document for the Envelope
            dfsle.Document myDocument = dfsle.Document.fromTemplate(
                myTemplateId, // templateId in dfsle.UUID format
                envelopeData.Name); // name of the template
            
            //add document to the Envelope
            myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });
            
            // Send the envelope.
            myEnvelope = dfsle.EnvelopeService.sendEnvelope(
                myEnvelope, // The envelope to send
                true); // Send now?                
        }        
    }
    
    /* A3SHCRSF3-10
     * Method Name:  getSObjectName
     * Params: sObjectIds : Its list of SObjectId 
     * Return: List<String>: It will return Object API Name   
     * Description: It is Invocable method called from flow "EnvelopeStatus: Update Respective SObject Action based on SourceId" 
					and once Flow sends SObjectId as input params then it will retrieve the Object API Name
     */
    @InvocableMethod(label ='Get SObject Name' description= 'Gets Object Name based on Ids')
    public static List<String> getSObjectName(List<Id> sObjectIds){
        return new List<String>{GlobalUtil.getSObjectName(sObjectIds)};
    }
}