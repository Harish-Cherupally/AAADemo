@istest
public class UpdateWOBasedONCustomerResp_Test {
static testMethod void TestinBoundEmail()
      {
        try{
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();                               
            Account acc = new Account();
            //acc.RecordTypeId = '012030000008kwvAAA';
            acc.RecordTypeId = recordTypeId;
            acc.Name = 'Testing';
            insert acc;
            
            Contact Con = new Contact();
            con.LastName = 'sample';
            con.Email = 'someaddress@email.com';
            con.AccountId = acc.Id;
            Insert con;
            
            WorkOrder wo1 = new WorkOrder();
            wo1.ContactId = con.Id;             
            wo1.Status = 'New';
            wo1.Assigned_Dealer__c = acc.Id;
            insert wo1;
            
            workorder wo = [select id, WorkOrderNumber from WorkOrder where id=: wo1.id];
            System.debug('*****'+wo.WorkOrderNumber);
            Messaging.InboundEmail email = new Messaging.InboundEmail() ;
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            
            email.subject = 'Create Contact';
            email.fromAddress = 'someaddress@email.com';
            string resp='';
            resp+=  'Yes';
            resp+='</br>';
            resp+='#$'+ wo.WorkOrderNumber +'#$';
            email.plainTextBody  = resp;
            system.debug('#$'+ wo.WorkOrderNumber +'#$  Yes');
            // Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            // attachment.body = blob.valueOf('my attachment text');
            //attachment.fileName = 'textfileone.txt';
            //  attachment.mimeTypeSubType = 'text/plain';
            //  email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            UpdateWOBasedONCustomerResp  testInbound=new UpdateWOBasedONCustomerResp();
            testInbound.handleInboundEmail(email, env);
            
        } catch(exception e) {
            system.debug('***e***'+e.getMessage());
            
        }
    }
    static testMethod void TestinBoundEmail2()
        
    {
        try{
            Account acc = new Account();
            acc.RecordTypeId = '012030000008kwvAAA';
            acc.Name = 'Testing';
            insert acc;
            
            Contact Con = new Contact();
            con.LastName = 'sample';
            con.Email = 'someaddress@email.com';
            con.AccountId = acc.Id;
            Insert con;
            
            WorkOrder wo1 = new WorkOrder();
            wo1.ContactId = con.Id;             
            wo1.Status = 'New';
            wo1.Assigned_Dealer__c = acc.Id;
            insert wo1;
                        
            workorder wo = [select id, WorkOrderNumber from WorkOrder where id=: wo1.id];
            System.debug('*****'+wo.WorkOrderNumber);
            Messaging.InboundEmail email = new Messaging.InboundEmail() ;
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            
            email.subject = 'Create Contact';
            email.fromAddress = 'someaddress@email.com';
            string resp='';
            resp+=  'No';
            resp+='</br>';
            resp+='#$'+ wo.WorkOrderNumber +'#$';
            email.plainTextBody  = resp;
            system.debug('#$'+ wo.WorkOrderNumber +'#$  Yes');
            
            UpdateWOBasedONCustomerResp  testInbound=new UpdateWOBasedONCustomerResp();
            testInbound.handleInboundEmail(email, env);
                                              
        } catch(exception e) {
            system.debug('***e***'+e.getMessage());
            
        }
    } 


}