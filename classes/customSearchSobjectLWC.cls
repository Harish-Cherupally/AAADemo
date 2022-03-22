public with sharing class customSearchSobjectLWC {
    @AuraEnabled(cacheable=true)
    public static list<contact> getContactList(string searchKey) {
        string searchKeyword = '%' + searchKey + '%';
        system.debug('searchKey>>> '+searchKey);
       // create contact list to store search result 
        list<contact> contactListRecord = new list<contact>();
     
       // query contact records
        for(Contact conObj : [Select id,Name,Email,FirstName,LastName,Phone From Contact WHERE name LIKE : searchKeyword]){
           contactListRecord.add(conObj);
        }
        
         if(contactListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
         }
         
        return contactListRecord;
    }

    @AuraEnabled(cacheable=true)
    public static List<Sobject> fetchRecords(String query) {
        return Database.query(query);
    }
}