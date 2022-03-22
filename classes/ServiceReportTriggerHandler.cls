public class ServiceReportTriggerHandler{
    public static void afterInsert(List<ServiceReport> newList){
        sendEmailtoSAContact(newList);
    }
    public static void sendEmailtoSAContact(List<ServiceReport> newList){
        set<Id> setServiceAppointmentIds = new set<Id>();
        set<Id> setContentDocumentIds = new set<Id>();
        List<ServiceReport> processList = new List<ServiceReport>();
        for(ServiceReport sr:newList){
            if(sr.IsSigned){
                processList.add(sr);
                setServiceAppointmentIds.add(sr.ParentId);
                System.debug('ContentVersionDocumentId@@@'+sr.ContentVersionDocumentId);
                setContentDocumentIds.add(sr.ContentVersionDocumentId);
            }
        }
        Map<Id,ContentVersion> MapContentDocuments = new Map<Id,ContentVersion>([SELECT Id, Title, ContentDocumentId, VersionData FROM ContentVersion where Id IN:setContentDocumentIds]);
                
        Map<Id, ServiceAppointment> serviceAppointmentMap = new Map<Id, ServiceAppointment>([select Id, ContactId from ServiceAppointment where Id IN:setServiceAppointmentIds]);
        
        EmailTemplate et = [select Id, Name from EmailTemplate where Name='Service Report Email Template'];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'a3sh-specialists@a3smarthome.com'];
        
        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
        for(ServiceReport sr:newList){
            if(serviceAppointmentMap.containsKey(sr.ParentId) 
                && serviceAppointmentMap.get(sr.ParentId).ContactId != null
                && MapContentDocuments.containsKey(sr.ContentVersionDocumentId)){

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(serviceAppointmentMap.get(sr.ParentId).ContactId);
                mail.setTemplateID(et.Id);
                mail.setWhatId(sr.ParentId);
                //mail.setTreatTargetObjectAsRecipient(false);
                //mail.setToAddresses(new list<string>{'yourEmail@gmail.com'});//To test uncomment and mention your email
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                
                
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(sr.ServiceReportNumber+'.pdf');
                efa.setBody(MapContentDocuments.get(sr.ContentVersionDocumentId).VersionData);
                
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                lstMails.add(mail);
            }
        }
        if(!lstMails.isEmpty()){
            Messaging.sendEmail(lstMails);   
        }
    }
}