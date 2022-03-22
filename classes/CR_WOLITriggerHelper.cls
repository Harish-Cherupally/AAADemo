public class CR_WOLITriggerHelper{
public static boolean stopReccursive = false;
    public static void updateAssetAfterWOLIUpdated(List<WorkOrderLineItem> newWOLIList, Map<Id,WorkOrderLineItem> oldMap){
    system.debug('inside update assets >>>' );
        Set<Id> woliIdSet= new Set<Id>();
        Set<Id> workOrderIdSet= new Set<Id>();
        boolean assetOperations = false;
        Map<Id, WorkOrder> woDetailsByWoIDMap = new Map<ID, WorkOrder>();
        //boolean assetOperationsForWOLIAddOn = false
        for(WorkOrderLineItem woliRec:  newWOLIList){
            woliIdSet.add(woliRec.Id);
            workOrderIdSet.add(woliRec.WorkOrderId);
            if(woliRec.Installed_Quantity__c != oldMap.get(woliRec.Id).Installed_Quantity__c && woliRec.Installed_Quantity__c>0 && woliRec.Product_Type__c != 'Add-On' && woliRec.Service_Type__c != 'Service Appointment'){
                assetOperations = true;
                
            }
        }
        
        //woDetailsByWoIDMap = new Map<ID, WorkOrder>([select Id,CaseId, AccountId,Account.Name, ContactId, Opportunity__c from WorkOrder where Id IN:workOrderIdSet]);
        
        
        
        if((assetOperations && !stopReccursive) || test.isRunningTest() ){
            
        woDetailsByWoIDMap = new Map<ID, WorkOrder>([select Id,CaseId, AccountId,Account.Name, ContactId, Opportunity__c from WorkOrder where Id IN:workOrderIdSet]);
            double counterToInsert = 0;
            double counterToUpdateInstalled = 0;
            double counterToUpdatePurchased = 0;
            double counterToUpdateDeclined = 0;
            
            for(WorkOrderLineItem woliRec: newWOLIList){
            
                boolean isAssetSuccess;
                
                if(woliRec.Quantity > woliRec.Original_Quantity__c ){ 
                    counterToInsert = woliRec.Quantity - woliRec.Original_Quantity__c ;
                    
                    if(!woliRec.Asset_Insert_Operation__c){
                        insertAssets(woliRec, woDetailsByWoIDMap.get(woliRec.WorkOrderId), counterToInsert);
                    }
                    woliRec.Asset_Insert_Operation__c = true;
                    if(woliRec.Quantity == woliRec.Installed_Quantity__c){
                        
                        counterToUpdateInstalled = woliRec.Quantity ;
                        counterToUpdatePurchased = 0;
                        counterToUpdateDeclined = 0;
                        isAssetSuccess = updateAssets(woliRec,  counterToUpdateInstalled, counterToUpdatePurchased, counterToUpdateDeclined);
                        if(isAssetSuccess){
                            assetOperations = false;
                            woliRec.status = 'Completed';
                        }
                    }else if(woliRec.Quantity > woliRec.Installed_Quantity__c){
                        counterToUpdatePurchased = woliRec.Quantity - woliRec.Installed_Quantity__c;
                        counterToUpdateInstalled = woliRec.Installed_Quantity__c;
                        counterToUpdateDeclined = 0;
                        isAssetSuccess = updateAssets(woliRec,  counterToUpdateInstalled, counterToUpdatePurchased, counterToUpdateDeclined);
                        if(isAssetSuccess){
                            assetOperations = false;
                            woliRec.status = 'Cannot Complete';
                        }
                    }
                    
                }else if(woliRec.Original_Quantity__c > woliRec.Quantity){
                    counterToUpdateDeclined = woliRec.Original_Quantity__c - woliRec.Quantity;
                   
                    //isAssetSuccess = updateAssets(woliRec,  counterToUpdateInstalled, counterToUpdatePurchased, counterToUpdateDeclined);
                    
                    if(woliRec.Quantity == woliRec.Installed_Quantity__c){
                        counterToUpdateInstalled = woliRec.Quantity;
                        counterToUpdatePurchased =0;
                        //counterToUpdateDeclined =0;
                        isAssetSuccess = updateAssets(woliRec,  counterToUpdateInstalled, counterToUpdatePurchased, counterToUpdateDeclined);
                        if(isAssetSuccess){
                        
                            assetOperations = false;
                            woliRec.status = 'Completed';
                        }
                    }else if(woliRec.Quantity > woliRec.Installed_Quantity__c){
                        counterToUpdatePurchased = woliRec.Quantity - woliRec.Installed_Quantity__c;
                        counterToUpdateInstalled = woliRec.Installed_Quantity__c;
                        //counterToUpdateDeclined = 0;
                        isAssetSuccess = updateAssets(woliRec,  counterToUpdateInstalled, counterToUpdatePurchased, counterToUpdateDeclined);
                        if(isAssetSuccess){
                        
                            assetOperations = false;
                            woliRec.status = 'Cannot Complete';
                        }
                    }
                    
                }else if(woliRec.Quantity == woliRec.Original_Quantity__c && woliRec.Quantity ==  woliRec.Installed_Quantity__c){
                    counterToUpdateInstalled = woliRec.Installed_Quantity__c;
                    counterToUpdatePurchased = 0;
                    counterToUpdateDeclined = 0;
                    isAssetSuccess = updateAssets(woliRec,  counterToUpdateInstalled, counterToUpdatePurchased, counterToUpdateDeclined);
                    if(isAssetSuccess){
                        assetOperations = false;
                        woliRec.status = 'Completed';
                    }
                }
                
            
            }
            stopReccursive = true;
            
        }
        
    }
        
    public static void insertAssets( WorkOrderLineItem woliRec, WorkOrder woRec, double counterToInsert ){
        List<Asset> assetsToInsertList = new List<Asset>();
        
        for(integer i=1; i<=counterToInsert;i++){
                        Asset assetToInsert = new Asset();
                        assetToInsert.Name= woRec.Account.Name+' '+woliRec.Product2Id;
                        assetToInsert.AccountId= woRec.AccountId;
                        assetToInsert.ContactId= woRec.ContactId;
                        assetToInsert.Work_Order_Line_Item__c = woliRec.Id;
                        assetToInsert.Work_Order__c = woliRec.WorkOrderId;
                        assetToInsert.Product2Id = woliRec.Product2Id;
                        assetToInsert.Opportunity__c = woRec.Opportunity__c;
                        assetToInsert.Case__c = woRec.CaseId;
                        assetToInsert.Status = 'Purchased';
                        //assetToInsert.Name= woRec.Account.Name+' '+woliRec.Product2Id;
                        assetsToInsertList.add(assetToInsert);
                    }
                    
                    if(assetsToInsertList.size()>0){
                        insert assetsToInsertList;
                        //system.debug('in assetsToInsertList>>>>> '+assetsToInsertList);
                    }
                    
    
    }
    //4,2,2 , counterToUpdateInstalled = 2, counterToUpdateDeclined = 2
    public static boolean updateAssets( WorkOrderLineItem woliRec, double counterToUpdateInstalled, double counterToUpdatePurchased, double counterToUpdateDeclined ){
        boolean returnSuccess = false;
        List<Asset> assetsToUpdateList = new List<Asset>();
        List<Asset> assetList = [select Id, name, Work_order_Line_Item__c from Asset where Work_order_Line_Item__c =:woliRec.Id AND Status = 'Purchased'];
        integer declinedCounter = 1;
        integer installedCounter = 1;
        integer purchasedCounter = 1;
        
        for(Asset assetRec : assetList){

            if(counterToUpdateDeclined>0 && declinedCounter<=counterToUpdateDeclined){
                assetRec.Status = 'Declined';
                assetsToUpdateList.add(assetRec);
                declinedCounter++;
            }else if(counterToUpdateInstalled>0 && installedCounter<=counterToUpdateInstalled){
                assetRec.Status = 'Installed';
                assetRec.InstallDate = system.today();
                assetRec.Customer_Warranty_Expiration_Date__c = system.today().addMonths(12);
                assetsToUpdateList.add(assetRec);
                installedCounter++;
            }else if(counterToUpdatePurchased>0 && purchasedCounter <=counterToUpdatePurchased){
                assetRec.Status = 'Purchased';
                assetsToUpdateList.add(assetRec);
                purchasedCounter++;
            }
        }
        if(assetsToUpdateList.size()>0){
            try{
                Update assetsToUpdateList;
                returnSuccess = true;
            }catch(Exception ex){
                returnSuccess = false;
            }
        }
        return returnSuccess;
    }
    
    
    public static void InsertAssetAfterWOLICreated(List<WorkOrderLineItem> newWOLIList){
    
        Set<Id> woliIdSet= new Set<Id>();
        Set<Id> workOrderIdSet= new Set<Id>();
        boolean assetInsertOperations = false;
        Map<Id, WorkOrder> woDetailsByWoIDMap = new Map<ID, WorkOrder>();
        for(WorkOrderLineItem woliRec: newWOLIList){
            woliIdSet.add(woliRec.Id);
            workOrderIdSet.add(woliRec.WorkOrderId);
            if(woliRec.Quantity >0 && woliRec.PriceBookEntryId != null && woliRec.Product_Type__c == 'Add-on' && woliRec.Service_Type__c != 'Service Appointment' ){
                assetInsertOperations = true;
                
            }
        }
        
        
       // woDetailsByWoIDMap = new Map<ID, WorkOrder>([select Id, CaseId,AccountId,Account.Name, ContactId, Opportunity__c from WorkOrder where Id IN:workOrderIdSet]);
        if(assetInsertOperations ){
            woDetailsByWoIDMap = new Map<ID, WorkOrder>([select Id, CaseId,AccountId,Account.Name, ContactId, Opportunity__c from WorkOrder where Id IN:workOrderIdSet]);
            for(WorkOrderLineItem woliRec: newWOLIList){
                double counterToInsert = 0;
                counterToInsert = woliRec.Quantity;
                
                insertAssets(woliRec, woDetailsByWoIDMap.get(woliRec.WorkOrderId), counterToInsert);
            }
        }
    }
    
    public static void assetOperationsForWOLIAddOn(List<WorkOrderLineItem> newWOLIList,Map<id, WorkOrderLineItem> oldMap ){
        
        Set<Id> woliIdSet= new Set<Id>();
        Set<Id> workOrderIdSet= new Set<Id>();
        Map<id, WorkOrderLineItem> woliIdByWOLIDetailsMap = new Map<Id,WorkOrderLineItem>();
        Map<id, WorkOrder> woIdByWODetailsMap = new Map<Id,WorkOrder>();
        boolean isAssetSuccess;
        boolean assetInsertOperations = false;
       
        
        for(WorkOrderLineItem woliRec: newWOLIList){
            woliIdSet.add(woliRec.Id);
            workOrderIdSet.add(woliRec.WorkOrderId);
            if(woliRec.Quantity >0 && woliRec.PriceBookEntryId != null && woliRec.Product_Type__c == 'Add-on' && !stopReccursive && woliRec.Service_Type__c != 'Service Appointment'){
                assetInsertOperations = true;
                stopReccursive = true;
                woliIdByWOLIDetailsMap.put(woliRec.Id, woliRec);
                
            }
        }
        
         //woIdByWODetailsMap = new Map<ID, WorkOrder>([select Id, CaseId,AccountId,Account.Name, ContactId, Opportunity__c from WorkOrder where Id IN:workOrderIdSet]);
        //to fix 101 queries moving this into if condition
        if(assetInsertOperations){
        woIdByWODetailsMap = new Map<ID, WorkOrder>([select Id, CaseId,AccountId,Account.Name, ContactId, Opportunity__c from WorkOrder where Id IN:workOrderIdSet]);
            for(WorkOrderLineItem woliRec: newWOLIList){
            woliRec.Asset_Insert_Operation__c = false;
                double counterToInsert = 0;
                double counterToUpdateInstalled = 0;
                double counterToUpdatePurchased = 0;
                double counterToDecline = 0;
                if(woliIdByWOLIDetailsMap.containsKey(woliRec.Id)){
                    if(woliRec.Installed_Quantity__c == 0){
                        if(woliRec.Quantity >0 && oldMap.get(woliRec.Id).Quantity != woliRec.Quantity && oldMap.get(woliRec.Id).Quantity < woliRec.Quantity){
                            counterToInsert = woliRec.Quantity -oldMap.get(woliRec.Id).Quantity;
                            assetInsertOperations =false;
                            stopReccursive = true;
                            if(!woliRec.Asset_Insert_Operation__c){
                                insertAssets(woliRec, woIdByWODetailsMap.get(woliRec.WorkOrderId), counterToInsert);
                            }
                            woliRec.Asset_Insert_Operation__c = true;
                        }else if(woliRec.Quantity >0 && oldMap.get(woliRec.Id).Quantity != woliRec.Quantity && oldMap.get(woliRec.Id).Quantity > woliRec.Quantity){
                            counterToDecline = oldMap.get(woliRec.Id).Quantity - woliRec.Quantity;
                            isAssetSuccess = updateAssets(woliRec,  counterToUpdateInstalled, counterToUpdatePurchased, counterToDecline);
                            
                        }
                    }else if(woliRec.Installed_Quantity__c > 0){
                        if(woliRec.Quantity == woliRec.Installed_Quantity__c){
                            counterToUpdateInstalled = woliRec.Installed_Quantity__c;
                            isAssetSuccess = updateAssets(woliRec,  counterToUpdateInstalled, counterToUpdatePurchased, counterToDecline);
                            if(isAssetSuccess){
                                stopReccursive = true;
                                assetInsertOperations= false;
                                woliRec.status = 'Completed';
                            }
                        }else if(woliRec.Quantity > woliRec.Installed_Quantity__c){
                            counterToUpdateInstalled = woliRec.Installed_Quantity__c;
                            counterToUpdatePurchased = woliRec.Quantity - woliRec.Installed_Quantity__c;
                            isAssetSuccess = updateAssets(woliRec,  counterToUpdateInstalled, counterToUpdatePurchased, counterToDecline);
                            if(isAssetSuccess){
                                assetInsertOperations= false;
                                stopReccursive = true;
                                woliRec.status = 'Completed';
                            }
                        }
                        
                    }
                    
                }
            
            }
            
        }
    }
    
    
}