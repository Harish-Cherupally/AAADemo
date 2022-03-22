/*******
 * Created By : CR Team
 * Cerated Date : 1 st  Feb 2022
 * Description :Populate Count of Site Accounts on the Parent Account
 * JIRA Story : A3SHCRSF3-34
 * Modified History:
 * 
 * *******/

trigger CountSiteAccount on Account (After insert, After update , After Delete) {
    Set<id> ids= new Set<id>();
     Integer count = 0;
    
    if(Trigger.isInsert ){
        for(Account acc: Trigger.new){
            if(acc.ParentId!=null)
                ids.add(acc.ParentId);
           
        }

        if (ids.size()>0) {
            AccountTriggerHelper.PopulateInsertedChildAcCountonParent(ids);
        }
    }
    
    if(Trigger.isUpdate ){
        for(Account acc: Trigger.new){
            if(acc.ParentId!=null)
                ids.add(acc.ParentId);
           
        }

        if (ids.size()>0) {
            AccountTriggerHelper.PopulateupdatededChildAcCountonParent(Trigger.NewMap,Trigger.OldMap);
        }
    }


    if(Trigger.isDelete){
        for(Account acc: Trigger.old){
            if(acc.ParentId!=null)
                ids.add(acc.ParentId);
           
        }
        if (ids.size()>0) {
            AccountTriggerHelper.PopulateInsertedChildAcCountonParent(ids);
        }
      
    }
        
    
    
}