public class A3SH_EmailTempController {
    
    Public List<Contact> newContObj {get;set;}
    Public List<Contact> existContObj {get;set;}
    Public static Apigee__mdt apigeeCustomMetadata = Apigee__mdt.getInstance('Apigee_sync_username');
   
    
    Public A3SH_EmailTempController(){
         
        System.debug('apigeeCustomMetadata=='+ apigeeCustomMetadata);
        List<user> usr = new List<User>([Select Id FROM User WHERE Username =: apigeeCustomMetadata.Sync_Username__c]); 
        newContObj = new List<Contact>();
        existContObj = new List<Contact>();
        for(Contact con : [SELECT Id,Stages__c,Alarm__c, CustomerNumber__c	FROM Contact 
                           WHERE (CreatedDate = today   AND CreatedById =: usr[0].Id) ]){
            if(!newContObj.contains(con)){
               newContObj.add(con);  
            }
        }
         for(Contact con : [SELECT Id,Stages__c,Alarm__c, CustomerNumber__c	FROM Contact 
                            WHERE lastmodifiedDate = today  AND CreatedDate != today AND LastModifiedById =: usr[0].Id ]){
            if(!existContObj.contains(con)){
               existContObj.add(con);  
            }
        }  
    }

}