public class WOEmailsForDealers {
    ///Send  Work Order Deatails to Customer 
    @InvocableMethod(label='Passvaribale' description='Need to Pass data') 
    public static void sendWOEmialTODealer(List<id> WOIDS) {
        system.debug('WOIDS****'+WOIDS);
        list <DealerCustomerEmailFunction.FlowInputs> sendPFI= new list <DealerCustomerEmailFunction.FlowInputs>();
        
        list <workorder> woorderlst = [select Id,Duration,WorkOrderNumber,Labor_Price_Hour__c,Street,Address,city,state,Phone__c,
                                       country,PostalCode,Dealer_Millage_Rate__c,Contact.FirstName,Contact.lastName ,Contact.Email,
                                       Total_Labor_Estimated_Price_Details__c,Total_Price_All_Parts__c ,Tax__c,Total_TAX__c,
                                       Assigned_Dealer__c,Assigned_Dealer__r.BillingStreet, Assigned_Dealer__r.BillingCity, 
                                       Assigned_Dealer__r.BillingState,
                                       Assigned_Dealer__r.BillingPostalCode, 
                                       Assigned_Dealer__r.BillingCountry    
                                       
                                       
                                       from workorder where ID IN: WOIDS];
        
        
        contact con= [select id,FirstName,email,lastName,phone from contact  where accountID=:woorderlst[0].Assigned_Dealer__c AND email!= null limit 1];
        system.debug('con****'+con);
         system.debug('woorderlst****'+woorderlst);
        for (workorder WO : woorderlst){
            
            
            DealerCustomerEmailFunction.FlowInputs fi = new DealerCustomerEmailFunction.FlowInputs();
            fi.WOID=wo.id;
            fi.inputemail=con.Email;
            fi.FirstName=con.FirstName;
            fi.Lastname=con.lastName;
            fi.Phone=con.Phone; 
            fi.street=wo.Assigned_Dealer__r.BillingStreet;
            fi.city=wo.Assigned_Dealer__r.BillingCity;
            fi.State=wo.Assigned_Dealer__r.BillingState;
            fi.Country=wo.Assigned_Dealer__r.BillingCountry;
            fi.postalcode=wo.Assigned_Dealer__r.BillingPostalCode;
            fi.IsDealer=True;
            fi.contactID=con.id;
            sendPFI.add(FI);
            
        }
        
        //sendprice sp= new sendprice();
        DealerCustomerEmailFunction.invokeThisMethod (sendPFI) ;
        
        
    }
}