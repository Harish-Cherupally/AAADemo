/*******
 * Created By : CR Team
 * Cerated Date : 1 st  Feb 2022
 * Description :Populate a Count of Site Accounts on the Parent Account.This class is invoked from CountSiteAccount Trigger.
 * JIRA Story : 
 * Modified History:
 * 
 * *******/

public with sharing class AccountTriggerHelper {
    
    public static void PopulateInsertedChildAcCountonParent(set <id> ids){
    List<Account> accchild = new List<Account>([select id,Parentid from Account where Parentid IN: ids]);
            List<Account> accparent = new List<Account>([select id,No_Of_Site_Accounts__c from Account where id IN: ids]);
            for(Account ac: accparent){
                integer count =0;
                // Need to Remove the inside the forloop.
                for(Account acchild: accchild){
                    if(acchild.Parentid == ac.id)
                        count++;
                    }
                ac.No_Of_Site_Accounts__c = count;            
            }
            try{
                upsert accparent;
            }catch(DMLException ex){
                System.debug('Exception is '+ex);
            }
      
    }

    public static void PopulateupdatededChildAcCountonParent(Map<Id,Account> newaccMap, Map<Id,Account> oldaccMap){
        
        map<id,integer> parentIdMap = new map<id,integer>();
        list<account> updateAccList = new list<account>();
        for(account acc : newaccMap.values()){
            parentIdMap.put(acc.parentID,null);
        }
        for(account acc : oldaccMap.values()){
            parentIdMap.put(acc.parentID,null);
        }
        for(account acc : [select id,parentID from account where parentId in : parentIdMap.keySet()]){
            if(parentIdMap.containskey(acc.parentId)){
                if(parentIdMap.get(acc.parentId)==null){
                    parentIdMap.put(acc.parentId,1);
                }else{
                    parentIdMap.put(acc.parentId,parentIdMap.get(acc.ParentId)+1);
                }
            }
        }
        for(id accid : parentIdMap.keyset()){
            if(parentIdMap.get(accid)>0){
                updateAccList.add(new account(id=accid,No_Of_Site_Accounts__c=parentIdMap.get(accid)));
            }
        }
        if(!updateAccList.isEmpty()){
            try{
                System.debug('updateParentAcclst****'+updateAccList);
                update updateAccList;
            }catch(DMLException ex){
                System.debug('Exception is '+ex.getStackTraceString());
            }
        }
     /*List<Account> Newaccchild = new List<Account>([select id,Parentid from Account where Parentid =: newaccMap.values().ParentId ]);
     List<Account> Oldaccchild = new List<Account>([select id,Parentid from Account where Parentid =: oldaccMap.values().ParentId]);
        system.debug('***New Map*'+newaccMap);
         system.debug('**Old Map**'+oldaccMap);
        system.debug('****'+newaccMap.values().ParentId+'***'+oldaccMap.values().ParentId);
        
      system.debug('**Newaccchild**'+Newaccchild+'*Oldaccchild**'+Oldaccchild);
        
            List<Account> newaccparent = new List<Account>([select id,No_Of_Site_Accounts__c 
                                                            from Account 
                                                            where ID =: newaccMap.values().ParentId]);
            List<Account> oldaccparent = new List<Account>([select id,No_Of_Site_Accounts__c 
                                                            from Account 
                                                            where ID =: oldaccMap.values().ParentId]);  
            List<Account> updateParentAcclst = new List<Account>();                                                                                                      
            for(Account ac: newaccparent){
                
                integer count =0;
                // Need to Remove the inside the forloop.
                for(Account acchild: Newaccchild){
                    if(acchild.Parentid == ac.id)
                         system.debug('**acchild**'+acchild);
                        count++;
                    }
                ac.No_Of_Site_Accounts__c = count; 
                
                updateParentAcclst.add(ac);
            }
            for(Account ac: oldaccparent){
                integer count1 =0;
                // Need to Remove the inside the forloop.
                for(Account acchild: Oldaccchild){
                    if(acchild.Parentid == ac.id)
                        count1++;
                    }
                ac.No_Of_Site_Accounts__c = count1; 
                
                updateParentAcclst.add(ac);
            }
            try{
                 System.debug('updateParentAcclst****'+updateParentAcclst);
                update updateParentAcclst;
            }catch(DMLException ex){
                System.debug('Exception is '+ex);
            }*/
       
    }
}