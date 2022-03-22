public class QuoteController {
    
    public Id QuoteId {get;set;}
    public string pdfpreview {get;set;}
    public  SBQQ__Quote__c  quoterec{get;set;}
    public  List<SBQQ__Quote__c> quoteLst;
    public List<SBQQ__QuoteLine__c> QuoteLineItemLst;
    
    public  decimal InstallationCostsORlabor {get;set;}
    public  decimal TaxesShippingAndHandling {get;set;}
    public  decimal TotalEquipmentANdLaborCostsToFinance {get;set;}
    public SBQQ__Quote__c GetQuote()
    {
        TotalEquipmentANdLaborCostsToFinance=0.00;
       // pdfpreview='preview';
        system.debug('****QuoteId***'+QuoteId);
        quoterec  = [SELECT Id,name,SBQQ__PrimaryContact__r.lastName, SBQQ__PrimaryContact__r.Name,SBQQ__PrimaryContact__r.Email, SBQQ__Status__c,SBQQ__Account__c,SBQQ__Account__r.Organization__c,
                     Available_for_Financing_Amount__c,Equipment_Down_Payment_Amount__c,Monthly_Monitoring_Amount_NEW__c,Monthly_Monitoring_Amount__c,Monthly_Charge__c, Monthly_Finance_Amount__c,SBQQ__NetAmount__c,SBQQ__Account__r.Name,Total_Financed_Amount__c,SBQQ__SalesRep__c,SBQQ__SalesRep__r.Name FROM SBQQ__Quote__c 
                     WHERE Id =: QuoteId];
        TotalEquipmentANdLaborCostsToFinance +=quoterec.Available_for_Financing_Amount__c;
        return quoterec;
    }
    // TotalEquipmentANdLaborCostsToFinance +=quoterec.Available_for_Financing_Amount__c;
    
    public List<SBQQ__QuoteLine__c> GetQuoteLineItem()
    {
        InstallationCostsORlabor=0.00;
        TaxesShippingAndHandling=0.00;   
        
        QuoteLineItemLst  = [  SELECT Id, Name, SBQQ__Number__c, SBQQ__Group__c, SBQQ__Product__c,
                             SBQQ__ProductName__c,SBQQ__NetPrice__c,SBQQ__NetTotal__c,
                             SBQQ__Product__r.Name,SBQQ__Product__r.Family, 
                             SBQQ__ListPrice__c, SBQQ__Quantity__c,SBQQ__ListTotal__c
                             FROM SBQQ__QuoteLine__c 
                             WHERE SBQQ__Quote__c =:QuoteId AND SBQQ__Product__r.Family='Equipment' ];
        //calculations
        for (SBQQ__QuoteLine__c qli :QuoteLineItemLst ){
            if(qli.SBQQ__Product__r.Family=='Installment'){
                InstallationCostsORlabor+=qli.SBQQ__ListTotal__c;
            }
            if(qli.SBQQ__Product__r.Family=='Service'){
                TaxesShippingAndHandling+=qli.SBQQ__ListTotal__c;
            }
            
            // TotalEquipmentANdLaborCostsToFinance +=InstallationCostsORlabor+TaxesShippingAndHandling;
        }
        
        return QuoteLineItemLst;
    }
    
}