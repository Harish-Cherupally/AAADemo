//@isTest
public class TestDataFactory {
    public Static List<Account> createAccounts(Integer numOfAccs,Map<String,Object> fieldData,Boolean isInsert){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Account> testAccounts = new List<Account>();
        for(Integer i =0; i< numOfAccs; i++){
            Account testAccount = new Account();
            testAccount.Name = 'TestAcc '+ i;
            
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    testAccount.put(tempField, fieldData.get(tempField));           
                }
            }
            testAccounts.add(testAccount);               
        }
        
        if(isInsert){
            Database.insert(testAccounts, dml); 
        }
        return testAccounts;
    }
    
    
    //Create Parent Account
    public static List<Account> createParentAccounts(Integer numOfAccs,Map<String,Object> fieldData,Boolean isInsert){
        List<Account> parentAccountsList = new List<Account>();
        for(Integer i =0; i< numOfAccs; i++){
            Account parentAcc = new Account();
            parentAcc.Name = 'TestAcc ' + i;
            Id recordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('ParentAccount').getRecordTypeId();
            parentAcc.RecordTypeId=recordTypeId;
            
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    parentAcc.put(tempField, fieldData.get(tempField));           
                }
            }
            parentAccountsList.add(parentAcc);               
        }
        
        If(isInsert){
            insert parentAccountsList;
        }
        return parentAccountsList;
        
        
    }
    
      //Create Dealer Account
    public static List<Account> createDelaerAccounts(Integer numOfAccs,Map<String,Object> fieldData,Boolean isInsert){
        List<Account> parentAccountsList = new List<Account>();
        for(Integer i =0; i< numOfAccs; i++){
            Account parentAcc = new Account();
            parentAcc.Name = 'TestAcc ' + i;
            Id recordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            parentAcc.RecordTypeId=recordTypeId;
            
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    parentAcc.put(tempField, fieldData.get(tempField));           
                }
            }
            parentAccountsList.add(parentAcc);               
        }
        
        If(isInsert){
            insert parentAccountsList;
        }
        return parentAccountsList;
        
        
    }
    public static List<Account> createSiteAccounts(Integer numOfAccs,Map<String,Object> fieldData,Boolean isInsert){
        
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Account> siteAccountList = new List<Account>();
        for(Integer i=0; i< numOfAccs; i++){
            Account siteAcc = new Account();
            siteAcc.Name = 'Test Account' + i;
            Id recordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('SiteAccount').getRecordTypeId();
            siteAcc.RecordTypeId=recordTypeId;
            
            List<Account> parentAccList = createParentAccounts(numOfAccs,fieldDatas,true);
            siteAcc.parentId=parentAccList[i].id;
            
            
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    siteAcc.put(tempField, fieldData.get(tempField));           
                }
            }
            siteAccountList.add(siteAcc);               
        }
        
        if(isInsert){
            insert siteAccountList;
        }
        return siteAccountList;
        
    }
    //Contact Creation
    public static List<Contact> createContact(integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<Contact> contactList = new List<Contact>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Account> AccList = createAccounts(recordCount,fieldDatas,true);
        for(Integer i=0; i<recordCount; i++) {
            Contact contactObject = new Contact(LastName = 'TestContactLast'+(i+1),
                                               email='TestContactLast'+(i+1)+'@demo.com',
                                               FirstName='TestFName'+(i+1));
             contactList.add(contactObject);
        }
        if(isInsert){
            insert contactList;
        }
        return contactList;
    }
    
    //Opportunity Creation
    public static List<Opportunity> createOpportunity(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<Opportunity> opportunityList = new List<Opportunity>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Account> AccList = createAccounts(recordCount,fieldDatas,true);
        List<contact> listContact = createContact(recordCount,fieldDatas,true);
        for(Integer i=0; i<recordCount; i++) {
            Opportunity opportunityObject = new Opportunity(Name = 'TestContactLast'+(i+1),Type = 'Upgrade',
                                                            closeDate = system.today(), stageName = 'Prospecting',
                                                            Installation_type__c = 'Self Install',
                                                            Primary_contact__c =listContact[i].Id,
                                                            AccountId = AccList[i].id);
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    opportunityObject.put(tempField, fieldData.get(tempField));           
                }
            } 
            opportunityList.add(opportunityObject);
        }
        if(!opportunityList.isEmpty()){
            insert opportunityList;
        }
        return opportunityList;
        
    }
    // Create Contract
    public static List<Contract> createContract(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<Contract> contractList  = new List<Contract>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Account> AccList = createAccounts(recordCount,fieldDatas,true);
        Date d1 = system.today();
        List<Account> getAccList = createAccounts(recordCount,fieldDatas,true);
        for(Integer i=0; i<recordCount; i++) {
            Contract contratObject = new Contract(StartDate =d1,Status = 'Draft' , ContractTerm = 12,
                                                  AccountId = getAccList[i].Id);
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    contratObject.put(tempField, fieldData.get(tempField));           
                }
            }
            contractList.add(contratObject);
            
        }
        if(isInsert){
            insert contractList;
        }
        return contractList;
        
    }
    // Create Order
    public static List<Order> createOrder(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<Order> ordList  = new List<Order>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Account> accList = createAccounts(recordCount,fieldDatas,true);
        List<Contract> contraList = createContract(recordCount,fieldDatas,true);
        Date d1 = system.today();
        List<Account> getAccList = createAccounts(recordCount,fieldDatas,true);
        for(Integer i=0; i<recordCount; i++) {
            Order orderObject = new Order(EffectiveDate = D1, Status = 'Draft' , ContractId = contraList[i].Id,
                                          AccountId = getAccList[i].Id);
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    orderObject.put(tempField, fieldData.get(tempField));           
                }
            }
            ordList.add(orderObject);
            
        }
        if(isInsert){
            insert ordList;
        }
        return ordList;
        
    }
    //Create WorkOrder
    public static List<WorkOrder> createWorkOrder(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<WorkOrder> workOrderList  = new List<WorkOrder>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Contact> contactList = createContact(recordCount,fieldDatas,true);
        Date d1 = system.today();
        for(Integer i=0; i<recordCount; i++) {
            WorkOrder workorderObject = new WorkOrder(ContactId = contactList[i].Id, Status = 'New');
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    workorderObject.put(tempField, fieldData.get(tempField));           
                }
            }
            workOrderList.add(workorderObject);
        }
        if(isInsert){
            insert workOrderList;
        }
        return workOrderList;
    }
    //Create WorkOrderLineItem
    public static List<WorkOrderLineItem> createWorkOrderLineItem(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<WorkOrderLineItem> workOrderLineList  = new List<WorkOrderLineItem>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<WorkOrder> WorkOrderList = createWorkOrder(recordCount,fieldDatas,true);
        Date d1 = system.today();
        for(Integer i=0; i<recordCount; i++) {
            WorkOrderLineItem workorderLineObject = new WorkOrderLineItem(WorkOrderId = WorkOrderList[i].Id, Status = 'New');
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    workorderLineObject.put(tempField, fieldData.get(tempField));           
                }
            }
            workOrderLineList.add(workorderLineObject);
        }
        if(isInsert){
            insert workOrderLineList;
        }
        return workOrderLineList;
    }
    
    //Create Quote
    public static List<SBQQ__Quote__c> createQuote(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<SBQQ__Quote__c> quoteList  = new List<SBQQ__Quote__c>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Contact> contactList = createContact(recordCount,fieldDatas,true);
        List<Account> AccList = createAccounts(recordCount,fieldDatas,true);
        Date d1 = system.today();
        for(Integer i=0; i<recordCount; i++) {
            SBQQ__Quote__c quoteObject = new SBQQ__Quote__c(SBQQ__PrimaryContact__c = contactList[i].Id, SBQQ__Account__c = AccList[i].Id );
            If(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    quoteObject.put(tempField, fieldData.get(tempField));           
                }
            }
            quoteList.add(quoteObject);
        }
        if(isInsert){
            insert quoteList;
        }
        return quoteList;
    }
    //Create QuoteLine
    public static List<SBQQ__QuoteLine__c> createQuoteLine(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<SBQQ__QuoteLine__c> quoteLineList  = new List<SBQQ__QuoteLine__c>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<SBQQ__Quote__c> QuoteList = createQuote(recordCount,fieldDatas,true);
        Date d1 = system.today();
        for(Integer i=0; i<recordCount; i++) {
            SBQQ__QuoteLine__c quoteLineObject = new SBQQ__QuoteLine__c(SBQQ__Quote__c = QuoteList[i].Id);
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    quoteLineObject.put(tempField, fieldData.get(tempField));           
                }
            }
            quoteLineList.add(quoteLineObject);
        }
        if(isInsert){
            insert quoteLineList;
        }
        return quoteLineList;
    }
    // Create ServiceAppointment
    public static List<ServiceAppointment> createServiceAppointment(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<ServiceAppointment> ServiceAppointmentList  = new List<ServiceAppointment>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<SBQQ__Quote__c> QuoteList = createQuote(recordCount,fieldDatas,true);
        Date d1 = system.today();
        for(integer i=0; i<recordCount; i++) {
            ServiceAppointment ServiceAppointmentObject = new ServiceAppointment(ParentRecordId = QuoteList[i].Id,status = 'Completed',
                                                                                 Service_Type__c = 'Training');
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    ServiceAppointmentObject.put(tempField, fieldData.get(tempField));           
                }
            }
            ServiceAppointmentList.add(ServiceAppointmentObject);
        }
        if(isInsert){
            insert ServiceAppointmentList;
        }
        return ServiceAppointmentList;
    }
    // Create Product
    public static List<Product2> createProduct(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<Product2> productList  = new List<Product2>();
        for(Integer i=0; i<recordCount; i++) {
            Product2 productObject = new Product2(Name = 'Test',productCode  = 'SN-Completed',
                                                  Description = 'Training',isActive = true);
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    productObject.put(tempField, fieldData.get(tempField));           
                }
            }
            productList.add(productObject);
        }
        if(isInsert){
            insert ProductList;
        }
        return ProductList;
    }
    // Create PricebookEntry
    public static List<PricebookEntry  > createPricebookEntry(Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<PricebookEntry> pricebookEntryList  = new List<PricebookEntry>();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<Product2> product2List = createProduct(recordCount,fieldDatas,true);
        for(Integer i=0; i<recordCount; i++) {
            PricebookEntry standardPrice = new PricebookEntry();
            standardPrice.Pricebook2Id = Test.getStandardPricebookId();
            standardPrice.Product2Id = product2List[i].Id;
            standardPrice.UnitPrice = 100;
            standardPrice.IsActive = true;
            standardPrice.UseStandardPrice = false;
            If(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    standardPrice.put(tempField, fieldData.get(tempField));           
                }
            }
            pricebookEntryList.add(standardPrice);
        }
        If(isInsert){
            insert pricebookEntryList;
        }
        return pricebookEntryList;
    }
    // Create OpportunityLine Item
    public static List<OpportunityLineItem> createOpportunityLineItem (Integer recordCount,Map<String,Object> fieldData,Boolean isInsert){
        List<OpportunityLineItem> opportunityLineItem   = new List<OpportunityLineItem >();
        Map<String,Object> fieldDatas = new Map<String,Object>();
        List<PricebookEntry> pricebookEntryList = createPricebookEntry(recordCount,fieldDatas,true);
        List<Opportunity> opportunityList = createOpportunity(recordCount,fieldDatas,true);
        for(integer i=0; i<recordCount; i++) {
            OpportunityLineItem  opportunityLineItemObject = new OpportunityLineItem ();
            OpportunityLineItemObject.OpportunityId = opportunityList[0].Id;
            OpportunityLineItemObject.PricebookEntryId = pricebookEntryList[i].Id;
            OpportunityLineItemObject.UnitPrice = 7000;
            OpportunityLineItemObject.Quantity = 5;
            if(fieldData != null){
                for(String tempField :fieldData.keySet()){
                    opportunityLineItemObject.put(tempField, fieldData.get(tempField));           
                }
            }
            opportunityLineItem.add(opportunityLineItemObject);
        }
        if(isInsert){
            insert opportunityLineItem;
            system.debug('***OpportunityLineItem**'+opportunityLineItem);
        }
        return opportunityLineItem;
    }
    
}