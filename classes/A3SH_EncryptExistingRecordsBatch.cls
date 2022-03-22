/*******************************************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/31/2021
* @Description   : This is the batch apex class to encrypt the existing service appiontment record ids
*********************************************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
***************************************************************************************************************************
1. 
*******************************************************************************************************************************/
global class A3SH_EncryptExistingRecordsBatch implements Database.Batchable<sobject>,Database.stateful{
	//retrieve all the servie appointment records where the id is not encrypted
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('select Id,Tech_Encrypted_Id__c from serviceappointment Where Tech_Encrypted_Id__c = NULL');
    }
    //process the reocrds and encrypt the id and store it in tech_encyrpted_id__c field
    global void execute(Database.BatchableContext bc,List<ServiceAppointment> saList){
        Blob key = Blob.valueOf(System.Label.A3SH_CryptoKey);
        for(ServiceAppointment saObj : saList){
            Blob encryptedData = Crypto.encryptWithManagedIV('AES128',key,Blob.valueOf(saObj.Id));
            String encrptedData = EncodingUtil.base64Encode(encryptedData);
            saObj.Tech_Encrypted_Id__c = encrptedData;
        }
        update saList;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}