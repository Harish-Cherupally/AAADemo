public class SendPrice {
    public static string  EnterAdress='';
    public static String   FulName='' ;
    
    @InvocableMethod(label='Passvaribale' description='Need to Pass data') 
    public static void invokeThisMethod(List<FlowInputs> request) {
        Id Woid =request[0].WOID;
        string inputemail = request[0].inputemail;
        string flowipFirstName = request[0].FirstName;
        string flowiipLastname = request[0].Lastname;
        string FlowipPhone = request[0].Phone;
        string flowipstreet = request[0].street;
        string flowipcity = request[0].city;
        string flwipState = request[0].State;
        string flowipCoutry = request[0].Country;
        string flowippostalocode = request[0].postalcode;
        boolean isdelaer=request[0].IsDealer;
        id conID=request[0].contactID;
        
        FulName=flowiipLastname ;
        EnterAdress= +'  Address :'+ '<br/>';
        EnterAdress +=' Street : '+ flowipstreet + '<br/>';
        EnterAdress += ' City : '+ flowipcity + '<br/>';
        EnterAdress +=  'State : '+ flowipcity + '<br/>';
        EnterAdress +=  ' Country :'+ flowipCoutry +' ,Postal Code :'+ flowippostalocode +'<br/>';
        EnterAdress +=  ' Mobile  :'+ FlowipPhone +' <br/> <br/>';
        
        
        
        Sendemail(Woid , inputemail,FulName, EnterAdress,isdelaer,conID);
    }
    
    
    Public Static id  woid;  
    
    
    @InvocableVariable(label='EmailInput' description='Need to Pass email') 
    public  String email;
    public Static decimal subTotal=0.0; 
    public Static decimal taxRate=0.0;
    public Static decimal totalTax=0.0; 
    public Static String userName;
    //  @InvocableMethod(label='SentPrice' description='Send Price for Work Order')
    public static void   Sendemail(id woid ,string Email,string fullName, String ipAdress,boolean Isdealer,Id ContactId) {
        
        
        
        
        
        system.debug('Body***'+woid+'*****Email****'+Email); 
        list <workorder> woorderlst = [select Id,Duration,WorkOrderNumber,Labor_Price_Hour__c,Address,city,state,country,Dealer_Millage_Rate__c,
                                       Total_Labor_Estimated_Price_Details__c,Total_Price_All_Parts__c ,Tax__c,Total_TAX__c 
                                       from workorder where ID =:woid];
        
        list <Account> orgId = [SELECT Organization__c,Name FROM Account WHERE Id in (SELECT accountID FROM workorder where ID=:woid)];
        
        String user = orgId[0].Organization__c;
        
        userName = orgId[0].Name;
        
        String sign = null;
        
        String image='';
        if(user!=null){
            if(user.equalsIgnoreCase('AAA')){
                sign = 'AAA Team';
                image = '<html><body><img src = "https://a3smarthome--c.documentforce.com/servlet/servlet.ImageServer?id=0154v000004QXGm&oid=00D6g000000uwLQ&lastMod=1607711973000" width="100" height="100" /></body></html>';                                                                         
                
            }else if(user.equalsIgnoreCase('A3')){
                sign = 'A3 Team';
                image = '<html><body><img src = "https://a3smarthome--c.documentforce.com/servlet/servlet.ImageServer?id=0154v000004Qdee&oid=00D6g000000uwLQ&lastMod=1612562556000" width="100" height="100" /></body></html>';                                                                         
                
            }else{
                sign = 'Team';
            }
        }
        
        // String AAAImage = '<html><body><img src = "https://a3smarthome--partialsb--c.documentforce.com/servlet/servlet.ImageServer?id=0154v000004QXGm&oid=00D7X0000004bgu&lastMod=1607711973000 " /></body></html>';                                                                         
        // String A3Image = '<html><body><img src = "https://a3smarthome--partialsb--c.documentforce.com/servlet/servlet.ImageServer?id=0154v000004Qdee&oid=00D7X0000004bgu&lastMod=1612562556000 " /></body></html>';                                                                         
        
        String  TotalHTMLBody='';
        
        String WorkoderBody='';
        WorkoderBody+='<br/><br/><br/><br/><br/><br/> <br/><br/><br/><br/>';
        WorkoderBody+=image+' <br/><br/>';
        WorkoderBody += 'Hi ,' +' <br/>';
        WorkoderBody += 'Please find the Price Deailes of '+woorderlst[0].WorkOrderNumber + ' work order' +' <br/><br/>';
        
        
        taxRate = woorderlst[0].Tax__c;
        totalTax = woorderlst[0].Total_TAX__c;
        // Get Workorder Line Items body 
        
        string laborBody= SendPrice.getTableEmailBodyIntsall( woid);
        string equipmentBody= SendPrice.getTableEmailBodyequipment( woid);
        system.debug('Body***'+equipmentBody); 
        TotalHTMLBody+=WorkoderBody +' <br/> <br/>';
        
        TotalHTMLBody+=laborBody +' <br/> ';
        
        TotalHTMLBody+=equipmentBody;
        
        string emailBody2 = '';
        emailBody2+='<br/><br/><br/><br/> <br/><br/>';
        emailBody2+=image+' <br/><br/>';
        emailBody2 += 'Hi'+' '+ fullName +','+' <br/><br/>';
        emailBody2 += '   Please find attached work order Details.' +' <br/> <br/>';
        emailBody2 += '  Work Order Number : '+woorderlst[0].WorkOrderNumber +' <br/> <br/>';
        emailBody2 +=   ipAdress+ '<br/>';
        //  emailBody2 += ' City : '+ woorderlst[0].City +'  State : '+ woorderlst[0].State + ' Country :'+ woorderlst[0].Country +'<br/> <br/>';
        emailBody2 += '  Thanks ,'+  '<br/>';
        emailBody2 +=sign +' <br/><br/>';
        //Thanks sign,
        PDFGenerationService.generatePDF(TotalHTMLBody, Email, emailBody2,woid,Isdealer,ContactId);
    }
    
    
    
    
    public static string getTableEmailBodyequipment( id woid){
        
        String htmlBody = '';
        Decimal TotalMaterial = 0.0;  
        //open table..
        htmlBody = '<table border="1" style="border-collapse: collapse"><caption></caption><tr><th bgcolor="red">Material Description</th><th bgcolor="red">Price Per Unit</th><th bgcolor="red">Quantity</th><th bgcolor="red">Amount</th></tr>';
        
        //iterate over list and output columns/data into table rows...
        for (workOrderLineItem  WOLI : [SELECT AssetId, OrderId, Subtotal, TotalPrice, ListPrice, Discount, UnitPrice, Quantity, LineItemNumber,
                                        PricebookEntryId, Status, EndDate, StartDate, Description, Product2Id, WorkOrderId, Id, DurationType,
                                        Duration, Original_Total_Price__c, Product_Code__c, Opportunity_Id__c, Product2Id__c, Product_Family__c,
                                        Opportunity_Product__c, Original_Quantity__c, Original_Final_Price__c, Original_Discount__c,
                                        New_Sales_Price__c, New_Total_Price__c, New_Tax__c, New_Discount__c, Original_List_Price__c,
                                        Planned_Duration_Hrs__c, Actual_Duration_Hrs__c, Original_Sales_Price__c,
                                        Total_Tax__c, Total_Price_After_Tax__c, Total_Price_Before_Tax__c, Working_Quantity__c 
                                        FROM WorkOrderLineItem where WorkOrderId =: woid AND Product_Family__c= 'equipment']){
                                            
                                            
                                            
                                            system.debug('WOLI***'+WOLI);                            
                                            string Description= WOLI.Description;
                                            Decimal UnitPrice = WOLI.UnitPrice; if(WOLI.UnitPrice == 0){UnitPrice = 0;}
                                            Decimal Quantity = WOLI.Quantity; if(WOLI.Quantity == 0){Quantity = 0;}
                                            Decimal TotalPriceAfterTax  = (UnitPrice * Quantity); if(WOLI.Total_Price_After_Tax__c == 0){Quantity = 0;}
                                            
                                            htmlBody += '<tr><td>' + Description + '</td><td>' + UnitPrice + '</td><td>' + Quantity + '</td><td>' + TotalPriceAfterTax + '</td></tr>';
                                            TotalMaterial+=TotalPriceAfterTax;  
                                            // subTotal+=TotalMaterial;
                                            
                                        }
        
        //close table...
        htmlBody += '</table>' +'<br/>';       
        htmlBody += '<table border="1" align="right"><caption></caption><tr><th></th><th></th><th bgcolor="red">Material Total</th><th>'+ TotalMaterial +'</th></tr>';
        htmlBody += '</table>' +'<br/>';
        subTotal+=TotalMaterial;
        decimal total = subTotal + totalTax;
        htmlBody +='<table border="1" align="right"><tbody><tr><th scope="row">SUB TOTAL</th><td>'+ subTotal +'</td></tr><tr><th scope="row">TAX RATE %</th><td>'+ taxRate +'</td></tr><th scope="row">TOTAL TAX</th><td>'+ totalTax +'</td></tr><tr><th scope="row">TOTAL</th><td>'+ total +'</td></tr></tbody></table>';
        
        system.debug('Email Body: ' + htmlBody);   
        
        return htmlBody;
        
    }
    public static string getTableEmailBodyIntsall( id woid){
        
        String htmlBody = '';
        Decimal TotalLabor = 0.0;  
        subTotal = 0.0;
        //open table..
        htmlBody = '<table border="1" style="border-collapse: collapse"><caption></caption><tr><th bgcolor="red">Labour Description</th><th bgcolor="red">Hours</th><th bgcolor="red">Rate</th><th bgcolor="red">Amount</th></tr>';
        
        //iterate over list and output columns/data into table rows...
        for (workOrderLineItem  WOLI : [SELECT AssetId, OrderId, Subtotal, TotalPrice, ListPrice, Discount, UnitPrice, Quantity, LineItemNumber,
                                        PricebookEntryId, Status, EndDate, StartDate, Description, Product2Id, WorkOrderId, Id, DurationType,
                                        Duration, Original_Total_Price__c, Product_Code__c, Opportunity_Id__c, Product2Id__c, Product_Family__c,
                                        Opportunity_Product__c, Original_Quantity__c, Original_Final_Price__c, Original_Discount__c,
                                        New_Sales_Price__c, New_Total_Price__c, New_Tax__c, New_Discount__c, Original_List_Price__c,
                                        Planned_Duration_Hrs__c, Actual_Duration_Hrs__c, Original_Sales_Price__c,
                                        Total_Tax__c, Total_Price_After_Tax__c, Total_Price_Before_Tax__c, Working_Quantity__c 
                                        FROM WorkOrderLineItem where WorkOrderId =: woid AND Product_Family__c= 'Installment']){
                                            
                                            
                                            system.debug('WOLI***'+WOLI);                            
                                            string LabourDescription = WOLI.Description;
                                            Decimal Hours = WOLI.UnitPrice; if(WOLI.UnitPrice == 0){Hours = 0;}
                                            Decimal Rate = WOLI.Quantity; if(WOLI.Quantity == 0){Rate = 0;}
                                            Decimal Amount  = (Hours * Rate);
                                            TotalLabor+=Amount; 
                                            
                                            htmlBody += '<tr><td>' + LabourDescription + '</td><td>' + Hours + '</td><td>' + Rate + '</td><td>' + Amount + '</td></tr>';
                                            
                                        }
        
        
        
        //close table...
        htmlBody += '</table>' +'<br/>'; 
        //htmlBody +='<head><style>table {border-collapse: collapse;width: 50%;}</style></head>';
        htmlBody += '<table border="1" style="width: 50%"><caption></caption><tr><th></th><th></th><th bgcolor="red">Labor Total</th><th>'+ TotalLabor +'</th></tr>';
        htmlBody += '</table>';
        subTotal+=TotalLabor;
        
        
        system.debug('Email Body: ' + htmlBody);   
        
        return htmlBody;
        
    }
    
    
    
    
    public class FlowInputs{
        
        @InvocableVariable
        public Id WOID;
        
        @InvocableVariable
        public string  inputemail;
        @InvocableVariable
        public string  FirstName;
        
        @InvocableVariable
        public string  Lastname;
        
        @InvocableVariable
        public string  Phone;
        
        @InvocableVariable
        public string  street;
        
        @InvocableVariable
        public string  city;
        
        @InvocableVariable
        public string  State;
        
        @InvocableVariable
        public string  Country;
        
        @InvocableVariable
        public string  postalcode;
        
        @InvocableVariable
        public Boolean isDealer;
        @InvocableVariable
        public ID contactID;
    }
    
    public static Boolean validateEmail(String email) {
        Boolean res = true;
        
        
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: http://www.regular-expressions.info/email.html
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        
        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    }
}