@isTest
public class AutoSendDocuSignEnvelope_Batch_Test {
	
    @isTest
    private static void test_SchedularBatch_WO(){
        // Mock the DocuSign eSignature API
		dfsle.TestUtils.setMock(new dfsle.ESignatureAPIMock());
 	        
        System.runAs(dfsle.UserMock.createDocuSignSender()){
            
            List<dfsle__EnvelopeConfiguration__c> testTemplates = new List<dfsle__EnvelopeConfiguration__c>();
        testTemplates.add(new dfsle__EnvelopeConfiguration__c(Name = 'Work Order RIC',dfsle__DocuSignId__c = 'c13612ef-ec0e-4c55-9629-ff8c0f8bbc08'));
        insert testTemplates;
            
            //Create WO Records
            List<WorkOrder> testWOs = TestDataFactory.createWorkOrder(1,new Map<String,Object>{'Status'=>'Esign To Be Generated'},true);
            
            //get WO Details
            List<WorkOrder> woData = [SELECT Id,ContactId,Contact.Name,Contact.Email FROM WorkOrder WHERE Id =:testWOs[0].Id];
            
            // Create a test envelope with one document and one recipient
            dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(testWOs[0].Id))
                .withDocuments(new List<dfsle.Document> { 
                    dfsle.Document.fromTemplate(
                        dfsle.UUID.randomUUID(),
                        'Work Order RIC')
                })
                .withRecipients(new List<dfsle.Recipient> {
                    dfsle.Recipient.fromSource(
                        woData[0].Contact.Name,
                        woData[0].Contact.Email,
                        '555-1234-5678',
                        'Signer 1',
                        new dfsle.Entity(woData[0].contactId))
                });
            
            //Calling Schedular method
            Test.startTest();        
            
            AutoSendDocuSignEnvelope_Batch testBatch = new AutoSendDocuSignEnvelope_Batch();
            testBatch.execute(null);
            Test.stopTest();
        }
    }
    
    @isTest
    private static void test_getSObjectName(){
         //Create WO Records
        List<WorkOrder> testWOs = TestDataFactory.createWorkOrder(1,new Map<String,Object>{'Status'=>'Esign To Be Generated'},true);
        
        List<String> sobjectAPIName = AutoSendDocuSignEnvelope.getSObjectName(new List<Id>{testWOS[0].Id});
        
        System.assertEquals('WorkOrder', sobjectAPIName[0]);
    }
}