@isTest
public class woliAndAssetOperationsFromFlow_Test{
     static testMethod void setupTestData(){
         test.startTest();
    
    Account account_Obj= new Account ();
    account_Obj.Name = 'Test Account';
    insert account_Obj;
    
    Contact contact_Obj = new Contact();
    contact_Obj.FirstName = 'Test';
    contact_Obj.LastName = 'Contact';
    contact_Obj.AccountId= account_Obj.id;
    insert contact_Obj;
    
    Product2 product2_Obj = new Product2();
    OrderItem orderitem_Obj = new OrderItem ();
    
    Product2 p = new Product2();
        p.Name = ' Test Product ';
        p.Description='Test Product Entry For Product';
        p.productCode = 'SFDCPanther-123';
        p.isActive = true;
        //p.ProductFamily = '';
        insert p;
        
        // insert pricebook entry for the product
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;    
    
    Opportunity opportunity_Obj = new Opportunity();
          // Create Opportunity
        Opportunity opp = new Opportunity();
        opp.AccountId = account_Obj.Id;
        opp.Name = 'Test Opportunity';
        opp.Installation_Type__c = 'Professional Install';
        opp.CloseDate= System.Today();
        opp.StageName='New';
        opp.Pricebook2Id = standardPrice.Pricebook2Id;
        insert opp;
         
          OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.PricebookEntryId = standardPrice.Id;
        oppLineItem.UnitPrice = 7000;
        oppLineItem.Quantity = 5;
        insert oppLineItem;
         
    Case caseObj = new Case();
    caseObj.Description = 'Test';
    //caseObj.Work_Order__c = workorder_Obj.Id;
    insert caseObj;
    WorkOrder workorder_Obj = new WOrkOrder();
    workorder_Obj.Pricebook2Id = Test.getStandardPricebookId();
    workorder_Obj.AccountId = account_Obj.id;
    workorder_Obj.ContactId = contact_Obj.Id;
    workorder_Obj.CaseId = caseObj.Id;
         workorder_Obj.Opportunity__c=opp.id;
      
    insert workorder_Obj ;
    Map<Id,WorkOrderLineItem> woliOldMap = new Map<Id,WorkOrderLineItem>();
    List<WorkOrderLineItem> woliList = new List<WorkOrderLineItem>();
    WorkOrderLineItem workorderlineitem_Obj = new WorkOrderLineItem();
    workorderlineitem_Obj.PricebookEntryId = standardPrice .id;
    workorderlineitem_Obj.Quantity = 3;
    workorderlineitem_Obj.Original_Quantity__c = 3;
    workorderlineitem_Obj.Installed_Quantity__c = 3;
    workorderlineitem_Obj.WorkOrderId = workorder_Obj.Id;
    workorderlineitem_Obj.Product_Type__c = 'New Product';
    workorderlineitem_Obj.Product_Family__c ='Equipment';
          workorderlineitem_Obj.Opportunity_Product__c=oppLineItem.id;
        // workorderlineitem_Obj.Opportunity_Id__c=opp.id;
    insert workorderlineitem_Obj;
    woliList.add(workorderlineitem_Obj);
    
    List<Asset> assetList = new List<Asset>();
    
    Asset assetObj = new Asset();
    assetObj.AccountId= account_Obj.id;
    assetObj.ContactId = contact_Obj.Id;
    assetObj.Product2Id = p.id;
    assetObj.Quantity = 3;
          assetObj.Opportunity__c=opp.id;
          assetObj.Related_OpportunityLine_Id__c=oppLineItem.id;
    //assetObj.Original_Quantity__c = 3;
    //assetObj.Installed_Quantity__c = 3;
    assetObj.Work_Order__c = workorder_Obj.Id;
    assetObj.Name = 'New Product';
    assetObj.Related_OpportunityLine_Id__c = workorderlineitem_Obj.Id;
    insert assetObj ;
    assetList.add(assetObj);
    List<woliAndAssetOperationsFromFlow.FlowInputs > reqList = new  List<woliAndAssetOperationsFromFlow.FlowInputs >();
    woliAndAssetOperationsFromFlow.FlowInputs flowInput = new woliAndAssetOperationsFromFlow.FlowInputs();
    flowInput.woliId = woliList;
    flowInput.assetIds = assetList ;
    flowInput.woRecord =workorder_Obj;
    flowInput.caseRecId = caseObj.Id;
    reqList.add(flowInput);
    woliAndAssetOperationsFromFlow.updateAssetsWithWOLIids(reqList);
    test.StopTest();
     }
}