@istest
public class WOEmailsForDealers_Test {
    static testMethod void Testmethod1(){
        list <DealerCustomerEmailFunction.FlowInputs> sendPFI= new list <DealerCustomerEmailFunction.FlowInputs>();
       
       Contact con = new Contact();
       con.LastName = 'sample';
      con.Email = 'someaddress@email.com';
      Insert con;
        
       List<WorkOrder> WOList = TestDataFactory.createWorkOrder(5,null,True);
        List<Id> woIds = new List<Id>();
        for(WorkOrder wo :WOList){
            woIds.add(wo.Id);
            DealerCustomerEmailFunction.FlowInputs fi = new DealerCustomerEmailFunction.FlowInputs();
            fi.WOID=wo.id;
            fi.inputemail=con.Email;
            fi.FirstName=con.FirstName;
            fi.Lastname=con.lastName ;
            fi.Phone=con.Phone;
            fi.street=wo.Assigned_Dealer__r.BillingStreet;
            fi.city=wo.Assigned_Dealer__r.BillingCity;
            fi.State=wo.Assigned_Dealer__r.BillingState;
            fi.Country=wo.Assigned_Dealer__r.BillingCountry;
            fi.postalcode=wo.Assigned_Dealer__r.BillingPostalCode;
            fi.IsDealer=True;
            fi.contactID=con.id;
           sendPFI.add(FI) ;
           
        }
            
        
		WOEmailsForDealers.sendWOEmialTODealer(woIds);
      DealerCustomerEmailFunction.invokeThisMethod(sendPFI) ;
     
    }
}