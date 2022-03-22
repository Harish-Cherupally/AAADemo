/*******************************************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/26/2021
* @Description   : This apex class is calling from a FLOW (SA-EncryptServiceAppointmentId). Is used to 
*				   encrypt the service appointment record id using private crypto key. The Private Key is stored in 
*				   custom label A3SH_CryptoKey. The ecrypted value (on create) will be stored in Tech_Encrypted_Id__c field.
*********************************************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
***************************************************************************************************************************
1. 
*******************************************************************************************************************************/
public class A3SH_EncryptSAID {
    private static final string BLANK = '';
    private static final string AES128 = 'AES128';
    /*********************************************************************************************************************
     * @Description : This is the method is calling from FLOW. It is used to encrypt the service appointment record id 
     *  			  using the crypto algorithm on creation of service appointment record.
     * @Return Type : 
     * @Parameters  : List<EncryptData> serviceAppointmentData
     * *******************************************************************************************************************/
    @InvocableMethod(label='Encrypt - ServiceAppointmentId' description='This method is used to encrypt the service appointment record id when its created')
    public static void encryptSAID(List<EncryptData> serviceAppointmentData){   
        String serviceAppointmentId = BLANK;
        for(EncryptData edObj : serviceAppointmentData){
            serviceAppointmentId = edObj.serviceAppointmentId;
        }
        Blob key = Blob.valueOf(System.Label.A3SH_CryptoKey);
        Blob encryptedData = Crypto.encryptWithManagedIV(AES128,key,Blob.valueOf(serviceAppointmentId));
        String encrptedData = EncodingUtil.base64Encode(encryptedData);
        
        ServiceAppointment updateSARecord = new ServiceAppointment(Id=serviceAppointmentId,Tech_Encrypted_Id__c=encrptedData);
        update updateSARecord;
    }
    /**********************************************
     * Class to pass invocablevariables from FLOW
     * ********************************************/
    public class EncryptData{
        @InvocableVariable
        public String serviceAppointmentId;
    }

}