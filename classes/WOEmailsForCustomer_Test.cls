@isTest
public class WOEmailsForCustomer_Test {
    @isTest
    Static void method1(){
        List<WorkOrder> WOList = TestDataFactory.createWorkOrder(5,null,True);
        List<Id> woIds = new List<Id>();
        for(WorkOrder Ids :WOList){
            woIds.add(Ids.Id);
        }
        WOEmailsForCustomer.sendWOEmialTOCustomer(woIds);
    }
     @isTest Static void createFlowInputs() {
        List<WorkOrder> listofWO = [select id from WorkOrder];
        
        List<DealerCustomerEmailFunction.FlowInputs> reqList = new  List<DealerCustomerEmailFunction.FlowInputs >();
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
        fi.WOID = listofWO[0].id;
        reqList.add(fi);
    }
    
}