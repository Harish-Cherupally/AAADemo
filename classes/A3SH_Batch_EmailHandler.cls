public class A3SH_Batch_EmailHandler {
    
    Public static void stagesSuccess(){
        EmailTemplate ET = [SELECT Id From EmailTemplate WHERE DeveloperName = 'A3SH_StagesSuccessTemplate'];
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{};
       // toAddresses.add('srikanth.ponagant@norcal.aaa.com');
        toAddresses.addAll(getUsersList());
        System.debug('toAddresses'+ toAddresses);
        mail.setToAddresses(toAddresses);
        System.debug('mail'+ mail);
        mail.setSenderDisplayName('A3Sh');
        mail.setTargetObjectId(userInfo.getUserId());
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setTemplateId(ET.Id);
        System.debug('mail'+ mail);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
    }
    
    public static List<String> getUsersList(){
        
        List<String> emailUsers = new List<String>();
        for(Apigee_Email_Recipients__mdt eml : [SELECT Id, Email_Recipient__c FROM  Apigee_Email_Recipients__mdt]){
            
            if(!emailUsers.contains(eml.Email_Recipient__c)){
              emailUsers.add(eml.Email_Recipient__c);  
            }   
        }
        return emailUsers;        
    }

}