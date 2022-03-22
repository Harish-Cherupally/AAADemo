public class WOEmailsForCustomer {
    
    
    ///Send  Work Order Deatails to Customer 
    @InvocableMethod(label='Passvaribale' description='Need to Pass data') 
    public static void sendWOEmialTOCustomer(List<id> WOIDS) {
        
          list <DealerCustomerEmailFunction.FlowInputs> sendPFI= new list <DealerCustomerEmailFunction.FlowInputs>();
           
          list <workorder> woorderlst = [select Id,Duration,WorkOrderNumber,Labor_Price_Hour__c,Street,Address,city,state,Phone__c,country,
                                         PostalCode,Dealer_Millage_Rate__c,Contact.FirstName,Contact.lastName ,Contact.Email,
                                       Total_Labor_Estimated_Price_Details__c,Total_Price_All_Parts__c ,Tax__c,Total_TAX__c 
                                       from workorder where ID IN: WOIDS];
        
        for (workorder WO : woorderlst){
            
            DealerCustomerEmailFunction.FlowInputs fi = new DealerCustomerEmailFunction.FlowInputs();
        	fi.WOID=wo.id;
            fi.inputemail=wo.Contact.Email;
            fi.FirstName=wo.Contact.FirstName;
            fi.Lastname=wo.Contact.lastName ;
            fi.Phone=wo.Phone__c;
            fi.street=wo.Street;
            fi.city=wo.city;
            fi.State=wo.state;
            fi.Country=wo.country;
            fi.postalcode=wo.PostalCode;
            fi.IsDealer=False;
            fi.contactID=wo.ContactId;
            
           sendPFI.add(FI) ;
           
        }
        
        DealerCustomerEmailFunction sp= new DealerCustomerEmailFunction();
       DealerCustomerEmailFunction.invokeThisMethod	(sendPFI) ;
        
        
    }
    
  

    
   
}