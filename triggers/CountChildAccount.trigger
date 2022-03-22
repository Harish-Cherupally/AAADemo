trigger CountChildAccount on Account(after insert, after update, after delete) {
    Set<Id> Ids= new Set<Id>();

    List<Account> acclist = new List<Account>();

 
    
    if(Trigger.isInsert || Trigger.isUpdate){

        for(Account acc: Trigger.new){

            if(acc.ParentId!=null)

                Ids.add(acc.ParentId);

            acclist.add(acc);

        }

    }

     

    if(Trigger.isDelete){

       for(Account acc: Trigger.old){

            if(acc.ParentId!=null)
                Ids.add(acc.ParentId);

            acclist.add(acc);

        }
    }

    
    if (!Ids.isEmpty()) {
        List<Account> AccountToUpdate = new List<Account>();
        
        Map<Id, Integer> mapcount = new Map<Id, Integer>();
        
        for (AggregateResult ar : [SELECT COUNT(ID), ParentID FROM Account 
                                WHERE ParentID IN :Ids GROUP BY ParentID]) {
              Id accID = (ID)ar.get('ParentID');
            Integer count = (Integer)ar.get('expr0');
            Account acc1 = new Account(Id=accID);
            acc1.No_Of_Site_Accounts__c = count;
            AccountToUpdate.add(acc1);
        }
        
        

        if (!AccountToUpdate.isEmpty()) {
            update AccountToUpdate;
        }
    }
}