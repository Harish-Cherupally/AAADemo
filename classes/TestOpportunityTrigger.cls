@isTest
public class TestOpportunityTrigger {
    
    @testSetup static void setup() {
        
        // insert product
        Product2 p = new Product2();
        p.Name = ' Test Product ';
        p.Description='Test Product Entry For Product';
        p.productCode = 'SFDCPanther-123';
        p.isActive = true;
        insert p;
        
        // insert pricebook entry for the product
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;        
        
        // insert account
        Account acc = new Account(
            Name = 'SFDCPanther.com',
            Rating = 'Hot',
            Industry = 'Banking',
            BillingCity =  'Montevideo',
            BillingPostalCode = '70100',
            BillingState = 'CA',
            BillingStreet = 'lala',
            Phone = '9087654321'
        );
        insert acc;
        
        // Create Opportunity
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'Test Opportunity';
        opp.Installation_Type__c = 'Professional Install';
        opp.CloseDate= System.Today();
        opp.StageName='New';
        opp.Pricebook2Id = standardPrice.Pricebook2Id;
        insert opp;
        
        // Add product and Pricebook to the particular opportunity using OpportunityLineItem 
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.PricebookEntryId = standardPrice.Id;
        oppLineItem.UnitPrice = 7000;
        oppLineItem.Quantity = 5;
        insert oppLineItem;
        
        //Insert AssetList
        Asset ast = new Asset(Name='ass1',AccountId= acc.Id,Price=100,Product2=p,Quantity=1);
    insert ast;
    /*a = [select ID, Installation_Type__c,Name,Opportunity__c,Product2Id,Status,PurchaseDate,Price_Book_Id__c,Related_OpportunityLine_Id__c from Account where ID=:a.Id];
    system.assertEquals('RMS2345', a.Asset_Product_Codes__c);
    System.assertEquals('fam1', a.Asset_Product_Families__c);*/
        
        
        
    }
    
    @isTest static void TestInsertAssetsFromOpportunityLineItem() {
        
        List<Opportunity> optyList = [SELECT Id, IsWon, StageName, AccountId, Primary_Contact__c, Installation_Type__c, CloseDate FROM Opportunity LIMIT 1 ];
        
        Test.startTest();
        
        Map<Id, Opportunity> opty1 = new Map<Id, Opportunity>();
        opty1.put( optyList.get(0).Id, optyList.get(0) );
        
        List<Opportunity> optyList2 = [SELECT Id, IsWon, StageName, AccountId, Primary_Contact__c, Installation_Type__c, CloseDate FROM Opportunity LIMIT 1 ];
        optyList2.get(0).StageName = 'Closed Won';
        
        Map<Id, Opportunity> opty2 = new Map<Id, Opportunity>();
        opty2.put( optyList2.get(0).Id, optyList2.get(0) );
                
        OpportunityTriggerHelper.createAssetFromOpportunityLineItems( opty1, opty2 );
        
        Test.stopTest();
        
        List<Asset> assetList = [SELECT Id FROM Asset];
        System.assertEquals( 6, assetList.size() );
    } 
}