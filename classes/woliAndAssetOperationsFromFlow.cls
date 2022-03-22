public class woliAndAssetOperationsFromFlow{
    @invocableMethod
    public static void updateAssetsWithWOLIids(List<FlowInputs> listWOLILists){
        
        List<WorkOrderLineItem> woliRecords = new List<WorkOrderLineItem>();
        List<Asset> assetRecords = new List<Asset>();
        List<ProductRequired> listOfProductRequiredToInsert = new List<ProductRequired>();
        Id caseRecordId ;
        WOrkOrder woRecord = new WorkOrder();
        
        
        for(FlowInputs eachItem : listWOLILists){
            if( eachItem.woliId!= null && eachItem.woliId.size()>0){
                woliRecords.addAll(eachItem.woliId);
            }
            if(eachItem.assetIds!=null && eachItem.assetIds.size()>0){
                assetRecords.addAll(eachItem.assetIds);
            }
            caseRecordId =eachItem.caseRecId;
            woRecord = eachItem.woRecord;
        }
        Map<id, List<Asset>> oppLIIdByListOfAsset = new Map<id, List<Asset>>();
          List<Asset> assetsListToUpdate = new List<Asset>();
          for(Asset assetRec : assetRecords){
              if(assetRec.Related_OpportunityLine_Id__c != null){
                  if(!oppLIIdByListOfAsset.containsKey(assetRec.Related_OpportunityLine_Id__c)){
                      oppLIIdByListOfAsset.put(assetRec.Related_OpportunityLine_Id__c, new List<Asset>());
                  }
                  List<Asset> tempAssets = oppLIIdByListOfAsset.get(assetRec.Related_OpportunityLine_Id__c);
                  tempAssets.add(assetRec);
                  oppLIIdByListOfAsset.put(assetRec.Related_OpportunityLine_Id__c, tempAssets);
              }
          }
          
          for(WorkOrderLineItem woliRec : woliRecords){
              /*ProductRequired prodRequiredRecord = new ProductRequired();
              if(woliRec.Product_Family__c == 'Equipment'){
                  prodRequiredRecord.Product2Id =  woliRec.Product2Id;
                  prodRequiredRecord.ParentRecordId = woliRec.WorkOrderId;
                  prodRequiredRecord.QuantityRequired = woliRec.Quantity;
                  listOfProductRequiredToInsert.add(prodRequiredRecord);
              }*/
              system.debug('***woliRec.Opportunity_Product__c***'+woliRec.Opportunity_Product__c);
               system.debug('**oppLIIdByListOfAsset.containsKey(woliRec.Opportunity_Product__c)****'+oppLIIdByListOfAsset.containsKey(woliRec.Opportunity_Product__c));
              if(woliRec.Opportunity_Product__c != null && oppLIIdByListOfAsset.containsKey(woliRec.Opportunity_Product__c)){
                  for(Asset tempAsset : oppLIIdByListOfAsset.get(woliRec.Opportunity_Product__c) ){
                      tempAsset.Case__c = caseRecordId ; tempAsset.Work_Order__c = woliRec.WorkOrderId; tempAsset.Work_Order_Line_Item__c = woliRec.Id; tempAsset.Status = 'Purchased'; tempAsset.Installation_Type__c = tempAsset.Opportunity__r.Installation_Type__c;  //tempAsset.Name = '';
                      assetsListToUpdate.add(tempAsset);
                  }
              }
          }
          system.debug('assetsListToUpdate>>> '+assetsListToUpdate);
          system.debug('listOfProductRequiredToInsert>>> '+listOfProductRequiredToInsert);
          if(assetsListToUpdate.size()>0){
              update assetsListToUpdate;
          }
          if(listOfProductRequiredToInsert.size()>0){
              database.insert (listOfProductRequiredToInsert,false);
          }
          
          
    }

    public class FlowInputs{
    
        @InvocableVariable
        public List<WorkOrderLineItem> woliId;
        
        @InvocableVariable
        public list<Asset> assetIds;
        
        @InvocableVariable
        public WorkOrder woRecord;
        
        @InvocableVariable
        public Id caseRecId;
        
    }
}