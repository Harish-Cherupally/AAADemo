public class Quotetemplateview {

     public Id QuoteId {get;set;}
    public Id ids;
    public  SBQQ__Quote__c  quoterec{get;set;}
  public  List<SBQQ__Quote__c> quoteLst;
   public List<SBQQ__QuoteLine__c> QuoteLineItemLst;
  
    public  decimal InstallationCostsORlabor {get;set;}
  public  decimal TaxesShippingAndHandling {get;set;}
   public  decimal TotalEquipmentANdLaborCostsToFinance {get;set;}
   
    
     public  SBQQ__Quote__c quoterec1;
 
    public Quotetemplateview() {

    }

    public Quotetemplateview(ApexPages.StandardController stdController) {
        this.quoterec = (SBQQ__Quote__c)stdController.getRecord();
    }
    
     public SBQQ__Quote__c GetQuote()
    {
        ids = ApexPages.currentPage().getParameters().get('id');  
	TotalEquipmentANdLaborCostsToFinance=0;
        system.debug('****QuoteId***'+QuoteId);
 quoterec  = [SELECT Id,name,SBQQ__PrimaryContact__r.lastName,SBQQ__SalesRep__r.Email,SBQQ__SalesRep__r.phone, SBQQ__PrimaryContact__r.Name,SBQQ__PrimaryContact__r.Email, SBQQ__Status__c,SBQQ__Account__c,SBQQ__Account__r.Organization__c,SBQQ__Account__r.BillingPostalCode ,
                               Available_for_Financing_Amount__c,Equipment_Down_Payment_Amount__c,Monthly_Monitoring_Amount_NEW__c,Monthly_Monitoring_Amount__c,Monthly_Charge__c, Monthly_Finance_Amount__c,SBQQ__NetAmount__c,SBQQ__Account__r.Name,Total_Financed_Amount__c,SBQQ__SalesRep__c,SBQQ__SalesRep__r.Name FROM SBQQ__Quote__c 
                                WHERE Id =: ids];
       TotalEquipmentANdLaborCostsToFinance +=quoterec.Available_for_Financing_Amount__c;
								return quoterec;
    }

}