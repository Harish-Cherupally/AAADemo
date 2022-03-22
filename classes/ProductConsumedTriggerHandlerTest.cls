@isTest
public class ProductConsumedTriggerHandlerTest {
    
    @isTest
    Public static void updateServiceTicketCheck_method1(){
        
        Contact conObj = new Contact(FirstName = 'test', LastName = 'Test',phone='1234567890');
        Database.insert(conObj);
        Id prBook = Test.getStandardPricebookId();
        WorkOrder woObj = new WorkOrder(AccountId = conObj.AccountId,contactId = conObj.Id, 
                                        Status = 'New',Service_Type__c = 'Service Appointment',
                                        City = 'Cha', PostalCode = '21112',Pricebook2Id = prBook );
        Database.insert(woObj);
        
        Product_tax__c prTx = new Product_tax__c (Tax_Rate__c = 10, Zip_Code__c = '21112');
        insert prTx;
        
        priceBook2 pbt = new PriceBook2(name= 'testPrBook');
        insert pbt;
        Product2 prd = new Product2(Name = 'product1');
        insert prd;
        
        PriceBookEntry custPrPrice = new PriceBookEntry (PriceBook2Id = prBook, product2Id = prd.Id,unitPrice = 10,IsActive = true);
        insert custPrPrice;
        Test.startTest();
        ProductConsumed prCons = new ProductConsumed (unitPrice = 10, PricebookEntryId = custPrPrice.Id,
                                                     WorkOrderId = woObj.Id, QuantityConsumed = 1 );
        insert prCons;
        Test.stopTest();
              
        
    }

}