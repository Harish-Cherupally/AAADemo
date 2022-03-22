public class SendWODeatailsToDealer {
    
    
    public  SBQQ__Quote__c  quoterec{get;set;}
     public Id woids {get;set;}
     public Id woid {get;set;}
     public workorder WoRec {get;set;}
     public List<workOrderLineItem> workOrderLineItemLst{get;set;}
     public List<workOrderLineItem> workOrderLineItemEqupLst{get;set;}
    public SBQQ__Quote__c GetQuote()
    {
     
        system.debug('****woid ***'+woid );
         return quoterec;
    }
    public workorder GetWo()
    {
        

        system.debug('**woid *+'+woid );
     WoRec = [select Id,Duration,WorkOrderNumber,Labor_Price_Hour__c,Address,city,state,country,Dealer_Millage_Rate__c,
                 Total_Labor_Estimated_Price_Details__c,Total_Price_All_Parts__c ,Tax__c,Total_TAX__c 
                 from workorder where ID =:woid];
        
        list <Account> orgId = [SELECT Organization__c,Name FROM Account WHERE Id in (SELECT accountID FROM workorder where ID=:woid)];
        
        String user = orgId[0].Organization__c;
        
        // userName = orgId[0].Name;
        
        String sign = null;
        
        String image='';
        if(user!=null){
            if(user.equalsIgnoreCase('AAA')){
                sign = 'AAA Team';
                image = '<html><body><img src = "https://a3smarthome--c.documentforce.com/servlet/servlet.ImageServer?id=0154v000004QXGm&oid=00D6g000000uwLQ&lastMod=1607711973000" width="100" height="100" /></body></html>';                                                                         
                
            }else if(user.equalsIgnoreCase('A3')){
                sign = 'A3 Team';
                image = '<html><body><img src = "https://a3smarthome--c.documentforce.com/servlet/servlet.ImageServer?id=0154v000004Qdee&oid=00D6g000000uwLQ&lastMod=1612562556000" width="100" height="100" /></body></html>';                                                                         
                
            }else{
                sign = 'Team';
            }
        }
        return worec;
    }
    
    
    public List<workOrderLineItem> GetworkOrderLineItem()
    {
        // InstallationCostsORlabor=0.00;
        // TaxesShippingAndHandling=0.00;   
        
        workOrderLineItemLst  = [  SELECT AssetId, OrderId, Subtotal, TotalPrice, ListPrice, Discount, UnitPrice, Quantity, LineItemNumber,
                                 PricebookEntryId, Status, EndDate, StartDate, Description, Product2Id, WorkOrderId, Id, DurationType,
                                 Duration, Original_Total_Price__c, Product_Code__c, Opportunity_Id__c, Product2Id__c, Product_Family__c,
                                 Opportunity_Product__c, Original_Quantity__c, Original_Final_Price__c, Original_Discount__c,
                                 New_Sales_Price__c, New_Total_Price__c, New_Tax__c, New_Discount__c, Original_List_Price__c,
                                 Planned_Duration_Hrs__c, Actual_Duration_Hrs__c, Original_Sales_Price__c,
                                 Total_Tax__c, Total_Price_After_Tax__c, Total_Price_Before_Tax__c, Working_Quantity__c 
                                 FROM WorkOrderLineItem where WorkOrderId =: woid AND Product_Family__c= 'Installment' ];
        //calculations
        for (workOrderLineItem WOLI :workOrderLineItemLst ){
            string Description= WOLI.Description;
            Decimal UnitPrice = WOLI.UnitPrice; if(WOLI.UnitPrice == 0){UnitPrice = 0;}
            Decimal Quantity = WOLI.Quantity; if(WOLI.Quantity == 0){Quantity = 0;}
            Decimal TotalPriceAfterTax  = (UnitPrice * Quantity);
            if(WOLI.Total_Price_After_Tax__c == 0){
                Quantity = 0;
            }
        }
        
        return workOrderLineItemLst;
    }
    public List<workOrderLineItem> GetworkOrderLineItemeuip()
    {
        // InstallationCostsORlabor=0.00;
        // TaxesShippingAndHandling=0.00;   
        
        workOrderLineItemEqupLst  = [  SELECT AssetId, OrderId, Subtotal, TotalPrice, ListPrice, Discount, UnitPrice, Quantity, LineItemNumber,
                                     PricebookEntryId, Status, EndDate, StartDate, Description, Product2Id, WorkOrderId, Id, DurationType,
                                     Duration, Original_Total_Price__c, Product_Code__c, Opportunity_Id__c, Product2Id__c, Product_Family__c,
                                     Opportunity_Product__c, Original_Quantity__c, Original_Final_Price__c, Original_Discount__c,
                                     New_Sales_Price__c, New_Total_Price__c, New_Tax__c, New_Discount__c, Original_List_Price__c,
                                     Planned_Duration_Hrs__c, Actual_Duration_Hrs__c, Original_Sales_Price__c,
                                     Total_Tax__c, Total_Price_After_Tax__c, Total_Price_Before_Tax__c, Working_Quantity__c 
                                     FROM WorkOrderLineItem where WorkOrderId =: woid AND Product_Family__c= 'equipment' ];
        //calculations
        for (workOrderLineItem WOLI :workOrderLineItemLst ){
            string Description= WOLI.Description;
            Decimal UnitPrice = WOLI.UnitPrice; if(WOLI.UnitPrice == 0){UnitPrice = 0;}
            Decimal Quantity = WOLI.Quantity; if(WOLI.Quantity == 0){Quantity = 0;}
            Decimal TotalPriceAfterTax  = (UnitPrice * Quantity);
            if(WOLI.Total_Price_After_Tax__c == 0){
                Quantity = 0;
            }
        }
        
        return workOrderLineItemEqupLst;
    }
}