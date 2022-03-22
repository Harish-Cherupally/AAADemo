public class ProductConsumedTriggerHandler {
    
    public static void updateServiceTicketCheck(List<ProductConsumed> newList){
        List<Id> workOrderIds = new List<Id>();
        Map<Id,String> wrkIdZipMap = new Map<Id,String>();
        Map<String, Decimal> zipTaxMap = new Map<String, Decimal>();
        
        try{
            for(ProductConsumed prCons :newList){
                if(!workOrderIds.contains(prCons.WorkOrderId)){
                    workOrderIds.add(prCons.WorkOrderId);    
                }       
            } 
            
            for(WorkOrder wrk : [SELECT Id,City, PostalCode FROM WorkOrder WHERE Id IN: workOrderIds AND Service_Type__c =: 'Service Appointment']){
                wrkIdZipMap.put(wrk.Id, wrk.PostalCode);    
            }
            
            for(Product_tax__c prTax : [SELECT Id,Tax_Rate__c,Zip_Code__c FROM Product_tax__c WHERE Zip_Code__c IN: wrkIdZipMap.values()]){
                zipTaxMap.put(prTax.Zip_Code__c, prTax.Tax_Rate__c);
            }
            for(ProductConsumed prCons :newList){
                
                if(wrkIdZipMap.containskey(prCons.WorkOrderId)){
                    prCons.Service_ticket_Check__c = true;
                    prCons.Discount__c = 0;
                    String PostCode = wrkIdZipMap.get(prCons.WorkOrderId);
                    if(zipTaxMap.containsKey(PostCode)){
                        prCons.Tax__c =  zipTaxMap.get(PostCode)*prCons.UnitPrice;
                        prCons.Total_Price__c = prCons.UnitPrice * prCons.QuantityConsumed ;
                        prCons.Final_Price__c = prCons.Total_Price__c + prCons.Tax__c;
                    }
                }       
            }
        }catch (Exception e){
            
        }   
    }    
}