@isTest
public class A3SH_StagesCalloutBatchClassTest {
	@testSetup
    static void setup() {
    	//Create test accounts
		for (integer recordNum = 500; recordNum <= 501; recordNum++) {
            // Create Account
            account a = new account();
            a.Name = 'Parent Account ' + recordNum;
            a.BillingStreet = '10' + recordNum + ' Billing Ave';
            a.BillingCity = 'San Ramon';
            a.BillingState = 'CA';
            a.BillingPostalCode = '94583';
            a.Phone = '9258304777';
            a.RecordTypeId = [Select Id From RecordType where sobjecttype = 'Account' and name = 'ParentAccount' LIMIT 1].Id;
            
            insert a;
            
            // Create Contact
            contact c = new contact();
            c.AccountId = a.Id;
            c.CustomerNumber__c = '18000' + recordNum;
            c.FirstName = 'Test';
            c.LastName = 'Contact ' + recordNum;
            c.Email = 'kyle.breen@a3smarthome.com';
            c.CustomerType__c = 'AAA SAFE';
            
            insert c;
                        
            // Create Site Account
            account sa = new account();
            sa.Name = 'Site Account ' + recordNum;
            sa.ShippingStreet = '10' + recordNum + ' Site Ave';
            sa.ShippingCity = 'Scottsdale';
            sa.ShippingState = 'AZ';
            sa.ShippingPostalCode = '85250';
            sa.Phone = '9259259250';
            sa.ParentId = a.Id;
            sa.RecordTypeId = [Select Id From RecordType where sobjecttype = 'Account' and name = 'SiteAccount' LIMIT 1].Id;
        
            insert sa;
            
            // Create Opportunity record
    		opportunity o = new opportunity();
            o.AccountId = sa.Id;
            o.Name = 'Opportunity for ' + a.Name;
            o.StageName = 'Closed';
            o.Probability = 100;
            o.CloseDate = Date.newInstance(2021, 12, 07);
            o.Type = 'New Installation';
            o.Primary_Contact__c = c.Id;
            o.Installation_Type__c = 'Professional Install';
            
            insert o;            
            
            // Create Work Order
            workorder w = new workorder();
            w.AccountId = sa.Id;
            w.ContactId = c.Id;
            w.Street = sa.ShippingStreet;
            w.City = sa.ShippingCity;
            w.State = sa.ShippingState;
            w.PostalCode = sa.ShippingPostalCode;
            w.Subject = 'New Installation';
            w.StartDate = system.now();
            //w.WorkTypeId = '08q3C0000008rGVQAY';
            //w.ServiceTerritoryId = '0Hh6g000000EIR1CAO';
            w.Opportunity__c = o.Id;
               
            insert w;
       }
    }
    @isTest static void testStagesCallout() {
        Test.startTest();
        A3SH_StagesCalloutBatchClass uca = new A3SH_StagesCalloutBatchClass();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
    }
    @isTest static void testStagesService() {
        List<contact> conList = [SELECT Id, AccountId, CustomerNumber__c, Email, CustomerType__c
            					FROM Contact 
            					Where AccountId != NULL AND CreatedDate = today AND Stages__c = FALSE 
            					AND Id NOT IN (Select ContactId FROM Asset WHERE type__c = 'Customer Systems') 
            					AND Id IN (Select ContactId FROM WorkOrder WHERE Opportunity__c <> '' AND Opportunity__r.Installation_Type__c <> 'Self Install' AND WorkOrderNumber <> '')];

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new A3SH_StagesMockAuth());
        
        System.debug('conList=='+ conList);
        
        Test.startTest();
        A3SH_StagesService.invokeService(conList);
        Test.stopTest(); 
    }    
}