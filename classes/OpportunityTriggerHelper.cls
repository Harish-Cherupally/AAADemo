public class OpportunityTriggerHelper {
    
    public static Boolean runTriggerOnlyOnce = true;
    
    public static void createAssetFromOpportunityLineItems( Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap ) {
        List<Asset> insertAssetList = new List<Asset>();
        List<String> allowedOptyIdsList = new List<String>();
        
        for( Opportunity opty : newMap.values() ){
            
            if(  opty.StageName == 'Closed Won' && oldMap.get(opty.Id).StageName != newMap.get(opty.Id).StageName ) 
              {
                  allowedOptyIdsList.add( opty.Id );
              }
            }
            for( OpportunityLineItem opp: [SELECT Id, Name, Quantity, Product2Id, OpportunityId, Product2.Standard_Pricebook_Entry_ID__c 
                                           FROM OpportunityLineItem  
                                           WHERE Product_Family__c != 'Recurring' AND Product_Family__c != 'Installment' AND Product_Family__c != 'Service' 
                                           AND OpportunityId IN: allowedOptyIdsList ]){
                Integer count = Integer.valueOf( opp.Quantity );
                //system.debug('count >>>> '+count );
                do {
                    insertAssetList.add( new Asset( 
                        AccountId = newMap.get(opp.OpportunityId).AccountId,
                        ContactId = newMap.get(opp.OpportunityId).Primary_Contact__c,
                        Installation_Type__c = newMap.get(opp.OpportunityId).Installation_Type__c,
                        Name = opp.Name,
                        Opportunity__c = opp.OpportunityId,
                        Product2Id = opp.Product2Id,
                        Status = 'Purchased',
                        PurchaseDate = newMap.get(opp.OpportunityId).CloseDate,
                        Price_Book_Id__c = opp.OpportunityId,
                        Related_OpportunityLine_Id__c = opp.Id
                    ) );
                    count--;
                } while ( count >0 );
            }
        
        
        if( !insertAssetList.isEmpty() ){
            runTriggerOnlyOnce = false;
            insert insertAssetList;
        }        
    }
    
    public static void updateInstallTypeBasedOnZipCode(List<Opportunity> newOpps,Map<Id,Opportunity> oldOppMap){               
        List<Id> accountIds = new List<Id>();
        List<Opportunity> changedOpps = new List<Opportunity>();
        
        for (Opportunity tempOpp :newOpps) {
            if(tempOpp.AccountId != null && (oldOppMap == null || (oldOppMap.get(tempOpp.Id).AccountId != tempOpp.AccountId))){
                accountIds.add(tempOpp.AccountId);
                changedOpps.add(tempOpp);
            }
        }
        
        if(accountIds.size() > 0){
            Map<Id,Account> accDetails = new Map<Id,Account>([SELECT Id, ShippingPostalCode 
                                                              FROM Account 
                                                              WHERE Id IN:accountIds]);
            List<String> accZipCodes = new List<String>();
            
            for(Account tempAcc :accDetails.values()){
                if(String.isNotBlank(tempAcc.ShippingPostalCode)){
                    accZipCodes.add(tempAcc.ShippingPostalCode);
                }
            }
            
            if(accZipCodes.size() > 0){
                Map<String,Zip_Code__c> zipCodeData = new Map<String,Zip_Code__c>();
                
                for(Zip_Code__c tempZipCode :[SELECT Id,Name,Self_Install__c,Pro_Install__c, Shipping_Price__c,Is_Dealer_Install_Available__c
                                              FROM Zip_Code__c 
                                              WHERE Name IN :accZipCodes]){
                    zipCodeData.put(tempZipCode.Name,tempZipCode);
                }
                
                if(zipCodeData.size() > 0){
                    for(Opportunity tempOpp :changedOpps){
                        if(tempOpp.AccountId != null && accDetails.containsKey(tempOpp.AccountId) && accDetails.get(tempOpp.AccountId).ShippingPostalCode != null){
                            String tempOppZipCode = accDetails.get(tempOpp.AccountId).ShippingPostalCode;
                            
                            if(zipCodeData.containsKey(tempOppZipCode)){
                                Zip_Code__c zipCodeRec = zipCodeData.get(tempOppZipCode);
                                
                                tempOpp.Is_Professional_Install_Available__c = zipCodeRec.Pro_Install__c;
                                tempOpp.Is_Dealer_Install_Available__c = zipCodeRec.Is_Dealer_Install_Available__c;
                                tempOpp.Is_Self_Install_Available__c = zipCodeRec.Self_Install__c;                                   
                            }
                        }
                    }
                }
            }           
        }
    }    
}