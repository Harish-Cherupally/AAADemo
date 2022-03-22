public class PDFGenerationService {
    public static void generatePDF(string Body , string Email,string emailBuilderbody,ID woid,boolean Isdealer,Id ConId)
    {
        
        
        EmailTemplate coverTemplate = EmailTemplateSelector.getEmailTemplate('WO Details body');
        EmailTemplate attachTemplate = EmailTemplateSelector.getEmailTemplate('WO Details body');
		if(attachTemplate!=null && coverTemplate!=null)
        {
            Map<String, String> ncParams=new Map<String, String> {'{name}' => ' Test USer'};
            Messaging.EmailFileAttachment attach = EmailHelper.attachementBuilder('Wo Price Details.pdf',Body,null);
           
            Messaging.SingleEmailMessage mail=EmailHelper.emailBuilder(Email,coverTemplate.Subject,emailBuilderbody,ncParams,woid,Isdealer,ConId);
           
	        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach}); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         
            
            Attachment att=new Attachment();
 		    att.Body=Blob.toPDF(body);
 		   att.Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.pdf';
		   att.parentId=woid;
            //Try Catch 
 		  insert att;
            
        }
    }
//Call vf page email templer in separte method(varibale workoderd id,Email)    
   
}
//PDFGenerationService.generatePDF();