public class EmailHelper {
    
    private static String setBodyValues(string body,Map<String,String> params){
        if(params!=null && params.size()>0){
            for(String key :params.keySet()){
                string val=params.get(key);
                body=body.replace(key,val);
                system.debug('body:'+body);
            }
        }
        return body;
    }
    
    
    public static Messaging.EmailFileAttachment attachementBuilder(string fileName,string emailHtml,Map<String,String> emailContent)
    {
        
      
        
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName(fileName);
        attach.setInline(true);
        String body=emailHtml;
        body=setBodyValues(body,emailContent);
        attach.Body = Blob.toPDF(body);
         
        return attach;
    }
    
    public static Messaging.SingleEmailMessage emailBuilder(String email,string subject,string emailHtml,Map<String,String> emailContent,id woid,boolean Isdealer,Id ConId)
    {
        List <OrgWideEmailAddress> orgemail;
        workorder WO = [select Id,Duration,WorkOrderNumber,Labor_Price_Hour__c,Address,city,state,country,Dealer_Millage_Rate__c,Assigned_Dealer__c, Assigned_Dealer__r.Name,
                                       Total_Labor_Estimated_Price_Details__c,Total_Price_All_Parts__c ,Tax__c,Total_TAX__c 
                                       from workorder where ID =:woid];
        if(Isdealer==True){
             //Email Inbound servie Email for Reply perpose
          orgemail= [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName='AAA Dealer Service' LIMIT 1]; 
        } else{
             orgemail= [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where DisplayName='AAA Customer Team' LIMIT 1];   
            
        }
    //  contact con= [select id,email from contact where accountID=:WO.Assigned_Dealer__c and email=:email limit 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
       
     
    
        
        mail.setUseSignature(false);
        mail.setToAddresses(new string[]{email});
        mail.setSubject(WO.WorkOrderNumber +'  work Order Details ');
        mail.setSaveAsActivity(true);
        mail.setTargetObjectId(ConId);
        mail.setWhatId(wo.id);
            //  mail.getOrgWideEmailAddressId(2F0D24v000000wk37);
        //  mail.getInReplyTo('a3sh-specialists@a3smarthome.com')
     string Wonumber=WO.WorkOrderNumber;
        string email1=orgemail[0].id;
        mail.setOrgWideEmailAddressId(email1); 
        string hide='<div style = display:none;>#$'+Wonumber+'#$ </div>';
        String body=emailHtml+'<br/>'+hide;
       
        //	body=setBodyValues(body,emailContent);
        mail.setHtmlBody(body);
        
           
        return mail;
        //String str2 = str1.substringBetween('#$@', '#$@');
    }
}