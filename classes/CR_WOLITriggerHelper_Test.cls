@isTest
public class CR_WOLITriggerHelper_Test{
WorkOrderLineItem workorderlineitem_Obj = new WorkOrderLineItem();
  
  static testMethod  void setupTestData(){
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
    Map<Id,WorkOrder > woMap = new Map<Id,WorkOrder >();
    List<WorkOrderLineItem> workorderlineitem_Objlist = new List<WorkOrderLineItem>();
    WorkOrder workorder_Obj = new WOrkOrder();
    workorder_Obj.Pricebook2Id = Test.getStandardPricebookId();
    workorder_Obj.AccountId = account_Obj.id;
    workorder_Obj.ContactId = contact_Obj.Id;
        
    insert workorder_Obj ;
    woMap.put(workorder_Obj.Id, workorder_Obj );
    Map<Id,WorkOrderLineItem> woliOldMap = new Map<Id,WorkOrderLineItem>();
    List<WorkOrderLineItem> woliList = new List<WorkOrderLineItem>();
    WorkOrderLineItem workorderlineitem_Obj = new WorkOrderLineItem();
    workorderlineitem_Obj.PricebookEntryId = standardPrice .id;
    workorderlineitem_Obj.Quantity = 3;
    workorderlineitem_Obj.Original_Quantity__c = 3;
    workorderlineitem_Obj.Installed_Quantity__c = 3;
    workorderlineitem_Obj.WorkOrderId = workorder_Obj.Id;
    workorderlineitem_Obj.Product_Type__c = 'New Product';
    insert workorderlineitem_Obj;
    woliList.add(workorderlineitem_Obj);
    workorderlineitem_Objlist.add(workorderlineitem_Obj);
    woliOldMap.put(workorderlineitem_Obj.Id, workorderlineitem_Obj);
    WorkOrderLineItem workorderlineitem_Obj2 = new WorkOrderLineItem();
    workorderlineitem_Obj2.PricebookEntryId = standardPrice .id;
    workorderlineitem_Obj2.Quantity = 3;
    workorderlineitem_Obj2.Original_Quantity__c = 1;
    //workorderlineitem_Obj2.Installed_Quantity__c = 3;
    workorderlineitem_Obj2.WorkOrderId = workorder_Obj.Id;
    workorderlineitem_Obj2.Product_Type__c = 'Add-On';
    
    insert workorderlineitem_Obj2;
    woliOldMap.put(workorderlineitem_Obj2.Id,workorderlineitem_Obj2);
    workorderlineitem_Obj2.Installed_Quantity__c = 0;
    workorderlineitem_Obj2.Quantity = 5;
    workorderlineitem_Obj2.Asset_Insert_Operation__c= true;
    update workorderlineitem_Obj2;
    woliList.add(workorderlineitem_Obj2);
    workorderlineitem_Objlist.add(workorderlineitem_Obj2);
    CR_WOLITriggerHelper.assetOperationsForWOLIAddOn(woliList, woliOldMap);
    
    woliOldMap.put(workorderlineitem_Obj2.Id,workorderlineitem_Obj2);
    workorderlineitem_Obj2.Installed_Quantity__c = 0;
    workorderlineitem_Obj2.Quantity = 2;
    //workorderlineitem_Obj2.Asset_Insert_Operation__c= true;
    update workorderlineitem_Obj2;
    woliList.add(workorderlineitem_Obj2);
    workorderlineitem_Objlist.add(workorderlineitem_Obj2);
    CR_WOLITriggerHelper.assetOperationsForWOLIAddOn(woliList, woliOldMap);
    
    workorderlineitem_Obj2.Installed_Quantity__c = 3;
    workorderlineitem_Obj2.Quantity = 5;
    workorderlineitem_Obj2.Status= 'Completed';
    //update workorderlineitem_Obj2;
    woliList.add(workorderlineitem_Obj2);
    workorderlineitem_Objlist.add(workorderlineitem_Obj2);
    CR_WOLITriggerHelper.assetOperationsForWOLIAddOn(woliList, woliOldMap);
    
    workorderlineitem_Obj2.Installed_Quantity__c = 5;
    workorderlineitem_Obj2.Quantity = 5;
    workorderlineitem_Obj2.Status= 'Completed';
    //update workorderlineitem_Obj2;
    woliList.add(workorderlineitem_Obj2);
    workorderlineitem_Objlist.add(workorderlineitem_Obj2);
    CR_WOLITriggerHelper.assetOperationsForWOLIAddOn(woliList, woliOldMap);
    
    
    workorderlineitem_Obj.Quantity = 4;
    workorderlineitem_Obj.Installed_Quantity__c = 4;
    //update workorderlineitem_Obj;
    
    Case case_Obj = new Case();
    
    Asset asset_Obj = new Asset(ContactId = contact_Obj.id, AccountId = account_Obj.id, Product2Id = product2_Obj.id, IsCompetitorProduct = false, Name = 'Name682', SerialNumber = 'Seria877', InstallDate = Date.today(), PurchaseDate = Date.today(), UsageEndDate = Date.today(), Status = 'Purchased', Price = 20, Quantity = 21, Description = '22',  SBQQ__Bundle__c = false, SBQQ__Bundled__c = false, SBQQ__ComponentDiscountedByPackage__c = false, SBQQ__FromServiceCloud__c = false, SBQQ__ListPrice__c = 46, SBQQ__MarkupAmount__c = 47, SBQQ__MarkupRate__c = 48, SBQQ__Number__c = 49, SBQQ__OptionDiscountAmount__c = 50, SBQQ__OptionDiscount__c = 51, SBQQ__OptionLevel__c = 52, SBQQ__OptionType__c = 'Component', SBQQ__OrderProduct__c = orderitem_Obj.id, SBQQ__UnitCost__c = 80, Customer_Warranty_Expiration_Date__c = Date.today(),    Opportunity__c = opportunity_Obj.id, Price_Book_Id__c = 'Price215', Work_Order__c = workorder_Obj.id, Case__c = case_Obj.id, Work_Order_Line_Item__c = workorderlineitem_Obj.id, Installation_Type__c = 'Professional Install');
    Insert asset_Obj; 
    
    double counterToInsert = 0;
            double counterToUpdateInstalled = 0;
            double counterToUpdatePurchased = 0;
            double counterToUpdateDeclined = 0;
    //List<Asset> asset_ObjList  =  [SELECT Id,ContactId,AccountId,ParentId,RootAssetId,Product2Id,IsCompetitorProduct,CreatedDate,IsDeleted,Name,SerialNumber,InstallDate,PurchaseDate,UsageEndDate,Status,Price,Quantity,Description,LocationId,LastViewedDate,LastReferencedDate,SBQQ__Bundle__c,SBQQ__Bundled__c,SBQQ__ComponentDiscountedByPackage__c,SBQQ__FromServiceCloud__c,SBQQ__ListPrice__c,SBQQ__MarkupAmount__c,SBQQ__MarkupRate__c,SBQQ__Number__c,SBQQ__OptionDiscountAmount__c,SBQQ__OptionDiscount__c,SBQQ__OptionLevel__c,SBQQ__OptionType__c,SBQQ__OrderProduct__c,SBQQ__UnitCost__c,SBQQ__VirtualAsset__c,Customer_Warranty_Expiration_Date__c,Equipment_Install_Description__c,Equipment_Installed_By__c,Equipment_Type__c,Opportunity__c,Price_Book_Id__c,Work_Order__c,Case__c,Work_Order_Line_Item__c,Installation_Type__c from Asset];
    //System.assertEquals(true,asset_ObjList.size()>0);
    //List<WorkOrderLineItem> workorderlineitem_Objlist = new List<WorkOrderLineItem>();
    CR_WOLITriggerHelper.stopReccursive = false;
    CR_WOLITriggerHelper obj01 = new CR_WOLITriggerHelper();
    //CR_WOLITriggerHelper.updateAssetAfterWOLIUpdated(workorderlineitem_Objlist ,woliOldMap);
    CR_WOLITriggerHelper.InsertAssetAfterWOLICreated(workorderlineitem_Objlist );
    CR_WOLITriggerHelper.insertAssets(workorderlineitem_Obj2,workorder_Obj ,1);
    CR_WOLITriggerHelper.updateAssets(workorderlineitem_Obj2,1,1,0);
    
    
    
    workorderlineitem_Objlist.add(workorderlineitem_Obj);
    //CR_WOLITriggerHelper.updateAssetAfterWOLIUpdated(workorderlineitem_Objlist ,woliOldMap);
    CR_WOLITriggerHelper.assetOperationsForWOLIAddOn(woliList, woliOldMap);
    
    test.stopTest();
  }
  
  
  static testMethod  void TestCaseMethod2(){
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
    Map<Id,WorkOrder > woMap = new Map<Id,WorkOrder >();
    List<WorkOrderLineItem> workorderlineitem_Objlist = new List<WorkOrderLineItem>();
    WorkOrder workorder_Obj = new WOrkOrder();
    workorder_Obj.Pricebook2Id = Test.getStandardPricebookId();
    workorder_Obj.AccountId = account_Obj.id;
    workorder_Obj.ContactId = contact_Obj.Id;
    workorder_Obj.Service_Type__c = 'New Installation';    
    insert workorder_Obj ;
    woMap.put(workorder_Obj.Id, workorder_Obj );
    Map<Id,WorkOrderLineItem> woliOldMap = new Map<Id,WorkOrderLineItem>();
    List<WorkOrderLineItem> woliList = new List<WorkOrderLineItem>();
    WorkOrderLineItem workorderlineitem_Obj = new WorkOrderLineItem();
    workorderlineitem_Obj.PricebookEntryId = standardPrice .id;
    workorderlineitem_Obj.Quantity = 3;
    workorderlineitem_Obj.Original_Quantity__c = 3;
    workorderlineitem_Obj.Installed_Quantity__c = 3;
    workorderlineitem_Obj.WorkOrderId = workorder_Obj.Id;
    workorderlineitem_Obj.Product_Type__c = 'New Product';
    //workorderlineitem_Obj.Service_Type__c = 'New Installation';
    insert workorderlineitem_Obj;
    //woliList.add(workorderlineitem_Obj);
   // workorderlineitem_Objlist.add(workorderlineitem_Obj);
    woliOldMap.put(workorderlineitem_Obj.Id, workorderlineitem_Obj);
    
    workorderlineitem_Obj.Original_Quantity__c = 5;
    workorderlineitem_Obj.Quantity = 4;
    workorderlineitem_Obj.Installed_Quantity__c = 4;
    workorderlineitem_Obj.Status= 'Completed';
    update workorderlineitem_Obj;
    workorderlineitem_Objlist.add(workorderlineitem_Obj);
    
    
    workorderlineitem_Obj.Quantity = 4;
    workorderlineitem_Obj.Installed_Quantity__c = 3;
    workorderlineitem_Obj.Status= 'Completed';
    update workorderlineitem_Obj;
    workorderlineitem_Objlist.add(workorderlineitem_Obj);
    
    Case case_Obj = new Case();
    
    Asset asset_Obj = new Asset(ContactId = contact_Obj.id, AccountId = account_Obj.id, Product2Id = product2_Obj.id, IsCompetitorProduct = false, Name = 'Name682', SerialNumber = 'Seria877', InstallDate = Date.today(), PurchaseDate = Date.today(), UsageEndDate = Date.today(), Status = 'Purchased', Price = 20, Quantity = 21, Description = '22',  SBQQ__Bundle__c = false, SBQQ__Bundled__c = false, SBQQ__ComponentDiscountedByPackage__c = false, SBQQ__FromServiceCloud__c = false, SBQQ__ListPrice__c = 46, SBQQ__MarkupAmount__c = 47, SBQQ__MarkupRate__c = 48, SBQQ__Number__c = 49, SBQQ__OptionDiscountAmount__c = 50, SBQQ__OptionDiscount__c = 51, SBQQ__OptionLevel__c = 52, SBQQ__OptionType__c = 'Component', SBQQ__OrderProduct__c = orderitem_Obj.id, SBQQ__UnitCost__c = 80, Customer_Warranty_Expiration_Date__c = Date.today(),    Opportunity__c = opportunity_Obj.id, Price_Book_Id__c = 'Price215', Work_Order__c = workorder_Obj.id, Case__c = case_Obj.id, Work_Order_Line_Item__c = workorderlineitem_Obj.id, Installation_Type__c = 'Professional Install');
    Insert asset_Obj; 
    
    double counterToInsert = 0;
            double counterToUpdateInstalled = 0;
            double counterToUpdatePurchased = 0;
            double counterToUpdateDeclined = 0;
    //List<Asset> asset_ObjList  =  [SELECT Id,ContactId,AccountId,ParentId,RootAssetId,Product2Id,IsCompetitorProduct,CreatedDate,IsDeleted,Name,SerialNumber,InstallDate,PurchaseDate,UsageEndDate,Status,Price,Quantity,Description,LocationId,LastViewedDate,LastReferencedDate,SBQQ__Bundle__c,SBQQ__Bundled__c,SBQQ__ComponentDiscountedByPackage__c,SBQQ__FromServiceCloud__c,SBQQ__ListPrice__c,SBQQ__MarkupAmount__c,SBQQ__MarkupRate__c,SBQQ__Number__c,SBQQ__OptionDiscountAmount__c,SBQQ__OptionDiscount__c,SBQQ__OptionLevel__c,SBQQ__OptionType__c,SBQQ__OrderProduct__c,SBQQ__UnitCost__c,SBQQ__VirtualAsset__c,Customer_Warranty_Expiration_Date__c,Equipment_Install_Description__c,Equipment_Installed_By__c,Equipment_Type__c,Opportunity__c,Price_Book_Id__c,Work_Order__c,Case__c,Work_Order_Line_Item__c,Installation_Type__c from Asset];
    //System.assertEquals(true,asset_ObjList.size()>0);
    //List<WorkOrderLineItem> workorderlineitem_Objlist = new List<WorkOrderLineItem>();
    CR_WOLITriggerHelper.stopReccursive = false;
    CR_WOLITriggerHelper obj01 = new CR_WOLITriggerHelper();
    CR_WOLITriggerHelper.updateAssetAfterWOLIUpdated(workorderlineitem_Objlist ,woliOldMap);
    //CR_WOLITriggerHelper.InsertAssetAfterWOLICreated(workorderlineitem_Objlist );
    //CR_WOLITriggerHelper.insertAssets(workorderlineitem_Obj,workorder_Obj ,1);
    //CR_WOLITriggerHelper.updateAssets(workorderlineitem_Obj,1,1,0);
    
    
    
    //workorderlineitem_Objlist.add(workorderlineitem_Obj);
    //CR_WOLITriggerHelper.updateAssetAfterWOLIUpdated(workorderlineitem_Objlist ,woliOldMap);
    //CR_WOLITriggerHelper.assetOperationsForWOLIAddOn(woliList, woliOldMap);
    
    test.stopTest();
  }
}