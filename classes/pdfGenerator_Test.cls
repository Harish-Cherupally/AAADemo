@isTest
Public class pdfGenerator_Test {
    
    
    static testMethod void testPdfGenerator() {
        
        String email= 'saikrishnapotturu@gmail.com';
        String emailBuilderbody='This is emailBuilderbody';
        String Body='This is Body';
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();        
                
        Account acc = new Account();
        acc.RecordTypeId = recordTypeId;
        acc.Name = 'Testing';
        insert acc;
        
        Contact Con = new Contact();
        con.LastName = 'sample';
        con.Email = 'someaddress@email.com';
        con.AccountId = acc.Id;
        Insert con;
        
        WorkOrder wo = new WorkOrder();
        wo.ContactId = con.Id;             
        wo.Status = 'New';
        wo.Assigned_Dealer__c = acc.Id;
        insert wo;
        
        pdfGenerator.generatePDF(Body, Email, emailBuilderbody, wo.Id , True, con.Id);
        
    }
    
}