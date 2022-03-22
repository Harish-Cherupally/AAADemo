@IsTest
public class SendPrice_Test {
    
    @testSetup Static void createData() {

       
        Account accObj = new Account(Name = 'test', Organization__c='AAAA');
        Database.insert(accObj);
        
        Contact conObj = new Contact(FirstName = 'testContact', LastName = 'Test',phone='1234567890', AccountId=accObj.Id);
        Database.insert(conObj);
        
        Opportunity oppObj = new Opportunity(accountId = conObj.AccountId, Name = 'Test Opportunity', StageName='Quote',CloseDate = System.today());
        Database.insert(oppObj);
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
        SendPrice.validateEmail('abc@gmail.com');
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
        List<WorkOrder> listofWO = [select id from WorkOrder];
        system.debug('listofWO : ' + listofWO );
        string Email = 'abc@gmail.com';
        string fullName= 'abc xyz' ;
        String ipAdress='';
        
        SendPrice.Sendemail(listofWO[0].id,Email,fullName,ipAdress);
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
        SendPrice.invokeThisMethod(reqList );
        
    }
}