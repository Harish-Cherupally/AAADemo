@IsTest
public class DealerCustomerEmailFunction_Test {
    
    @testSetup Static void createData() {
        
        
        Account accObj = new Account(Name = 'test', Organization__c='AAAA');
        Database.insert(accObj);
        
        Contact conObj = new Contact(FirstName = 'testContact', LastName = 'Test',phone='1234567890', AccountId=accObj.Id);
        Database.insert(conObj);
        
        Opportunity oppObj = new Opportunity(accountId = conObj.AccountId, Name = 'Test Opportunity', StageName='Quote',CloseDate = System.today());
        Database.insert(oppObj);
        oppObj.Installation_Type__c='Professional Install';
        oppObj.StageName='Closed Won';
        Database.update(oppObj);
        
        WorkOrder woObj = new WorkOrder(AccountId = conObj.AccountId,contactId = conObj.Id, opportunity__c = oppObj.Id,Status = 'New',Service_Type__c = 'New Installation');
        Database.insert(woObj);
        
        ServiceAppointment saObj = new ServiceAppointment(ParentRecordId = woObj.Id, contactId = conObj.Id,Opportunity__c = oppObj.Id);
        Database.insert(saObj);
        
        /*   Map<String,String> params = new Map<String,String>();
params.put('Testkey', 'testvalue');
EmailHelper.setBodyValues('TestBody',params);

*/
        
        //SendPrice TestData
        //SendPrice sp = new SendPrice();
        //Database.insert(sp);
        
        /*Test.startTest();//ToPreventGovernorLimit

SendPrice.getTableEmailBodyequipment('1'); //Method 1
SendPrice.getTableEmailBodyequipment(); //Method 2
SendPrice.getTableEmailBodyequipment(); //Method 3
SendPrice.getTableEmailBodyequipment(); //Method 4
SendPrice.getTableEmailBodyequipment(); //Method 5
SendPrice.getTableEmailBodyequipment(); //Method 6 


Test.stoptest(); //ToPreventGovernorLimit

*/    
    } 
    static testMethod void testMethod2() {
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        ServiceAppointment sa = new ServiceAppointment();
        sa.Status = 'Scheduled';
        sa.SchedStartTime = system.now().addHours(-5);
        sa.SchedEndTime = system.now().addHours(2);
        sa.ParentRecordId = acc.Id;
        insert sa;
        
        
    }
    
    
    
    @isTest Static void validateEmailpositive() 
    {
        String EmailId='ajith.allala@criticalriver.com';
        Boolean Value=SendPrice.validateEmail(EmailId);
        System.assertEquals(True,Value);
    }
    @isTest Static void validateEmailNegative()
    {
        SendPrice.validateEmail('abc@');
    }
    
    
    @isTest Static void createFlowInputs() {
        List<WorkOrder> listofWO = [select id from WorkOrder];
        
        List<SendPrice.FlowInputs > reqList = new  List<SendPrice.FlowInputs >();
        SendPrice.FlowInputs fi = new SendPrice.FlowInputs();
        fi.city ='Nagpur';
        fi.Country='India';
        fi.FirstName='Hitesh';
        fi.inputemail='hitesh.nimje@criticalriver.com';
        fi.Lastname='Nimje';
        fi.Phone='9371737577';
        fi.postalcode='440037';
        fi.State='Maharashtra';
        fi.street='Revati nagar besa';
        fi.WOID = listofWO[0].id;
        reqList.add(fi);
    }
    
    @isTest Static void SendemailPositive() {
        List<WorkOrder> WOList = [select id,contactID from WorkOrder];
        system.debug('WOList : ' + WOList[0] );
        string Email = 'ajith.allala@criticalriver.com';
        string fullName= 'ajith kumar' ;
        String ipAdress='';
        
        boolean isdelaer=true;
        id conID=WOList[0].contactID;
        
        DealerCustomerEmailFunction.Sendemail(WOList[0].id,Email,fullName,ipAdress,isdelaer,conID);
        List<DealerCustomerEmailFunction.FlowInputs > reqList = new  List<DealerCustomerEmailFunction.FlowInputs >();
        DealerCustomerEmailFunction.FlowInputs fi = new DealerCustomerEmailFunction.FlowInputs();
        fi.city ='Nagpur';
        fi.Country='India';
        fi.FirstName='Hitesh';
        fi.inputemail='hitesh.nimje@criticalriver.com';
        fi.Lastname='Nimje';
        fi.Phone='9371737577';
        fi.postalcode='440037';
        fi.State='Maharashtra';
        fi.street='Revati nagar besa';
        fi.WOID = WOList[0].id;
        reqList.add(fi);
        DealerCustomerEmailFunction.invokeThisMethod(reqList);
        
    }
    
    @isTest
    Public Static Void  getTableEmailBodyequipmentMethod()
    {
        List<WorkOrder> WOList=TestDataFactory.createWorkOrder(1,null,True);
        DealerCustomerEmailFunction.getTableEmailBodyequipment(WOList[0].Id);
    }
    
    @isTest
    Public Static Void  getTableEmailBodyInstall()
    {
        List<WorkOrder> WOList=TestDataFactory.createWorkOrder(1,null,True);
        DealerCustomerEmailFunction.getTableEmailBodyInstall(WOList[0].Id);
    }
    
}