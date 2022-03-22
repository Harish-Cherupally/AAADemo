@isTest
public class EmailConstructor_Test 
{
    
    
    @isTest
    Public Static Void Method1()
    {
        Map<String,String> par = new Map<String,String>();         
        par.put('Hello','Ajith@gmail.com');
        String Body ='Contains MailId';
        String BodyValue = EmailConstructor.setBodyValues(Body,par);   
        system.assertEquals('Contains MailId',BodyValue);
    }
    
    @isTest
    Public Static Void Method2()
    {
        Map<String,String> par = new Map<String,String>();       
        par.put('Hello','Ajith@gmail.com');
        
        String BodyValue='helloWorld';
        //C:\Users\Ajith\Documents\ASSIGNMENTS
        String FileName='Ajith.pdf';
        Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
        attach1.setContentType('application/pdf');
        attach1.setFileName(fileName);
        attach1.setInline(true);   
        Messaging.EmailFileAttachment Value =  EmailConstructor.attachementBuilder(FileName,BodyValue,par);
        system.debug(value);
        
    }
    
    
    @isTest
    Public Static Void Method3()
    {
        String EmailId='ajith.allala@criticalriver.com';
        String Subject ='WorkOrderDeatils';
        String EmailHtmlValue='helloWorld';
        Map<String,String> emailContents = new Map<String,String>();
        emailContents.put('Hello','Ajith@gmail.com');
        boolean IsdealerValue=True;
        List<WorkOrder> WOList=TestDataFactory.createWorkOrder(1,null,True);
        List<Contact> ConList=TestDataFactory.createContact(1,null,True);   
        EmailConstructor.emailBuilder(EmailId,Subject,EmailHtmlValue,emailContents,WOList[0].Id,IsdealerValue,ConList[0].Id);
        
        
        /* Test.startTest();  
System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');

System.assertEquals(1, Limits.getEmailInvocations(),'Email should be sent');
Test.stopTest(); */
    }
    
}