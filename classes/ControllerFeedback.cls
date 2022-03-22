public Without Sharing class ControllerFeedback {
    public String rejectionReason{set;get;}
    public Id ids;
    public SBQQ__Quote__c obj{set;get;}
    public String message{set;get;}
    public string  quotesstatus{set;get;}
    public Boolean ShowReasonform {set;get;}
    public Boolean ShowSucessUpdateMessage {set;get;}
    public String quoteAccountName{set;get;}
    public Boolean quoteA3Org{set;get;}
    public Boolean isSubmitted{set;get;}
    
    public ControllerFeedback(){
        //obj = new SBQQ__Quote__c();
    }

    public void init() {
        try{
            ids = ApexPages.currentPage().getParameters().get('id');  
            quotesstatus = ApexPages.currentPage().getParameters().get('Status');  
            system.debug('Id'+ids);
            system.debug('quotesstatus***'+quotesstatus);
            List<SBQQ__Quote__c> quoteList = [  SELECT Id, SBQQ__Status__c, 
                                                        Status_Update__c, SBQQ__Account__r.Name,
                                                        SBQQ__Account__r.Organization__c
                                                FROM SBQQ__Quote__c  
                                                WHERE id = :ids]; 
            
            quoteA3Org = false;
            isSubmitted = false;
            if( quoteList.size() > 0 ){
                obj = quoteList[0];
                quoteAccountName = obj.SBQQ__Account__r.Name;
                if( obj.SBQQ__Account__r.Organization__c == 'A3'){
                    quoteA3Org = true;
                }
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Invalid Id : '+ ids +'.'));
                return;
            }
            system.debug('obj***'+obj );
            // obj.SBQQ__Status__c= 'Approved';//quotesstatus
            if(obj.Status_Update__c == false ){
      // if( obj.SBQQ__Status__c != 'Client Accepted' &&  obj.SBQQ__Status__c != 'Client Rejected' ){
                if (quotesstatus == 'AcceptWithFull'){
                    obj.SBQQ__Status__c = 'Client Accepted';
                    obj.Credit_Score_Status__c = 'Not Required';
                     obj.Payment_Type__c='Pay Total Amount';
                   // obj.Status_Update__c = true;
                    obj.Quote_Status_Message__c = 'Client Accepted the Quote without finance, please generate Docusign and send it to Client.';
                    UPDATE obj; 
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Thank you for the Quote Feedback.'));
                }
                else if (quotesstatus == 'AcceptWithFinance'){
                    obj.SBQQ__Status__c = 'Client Accepted';
                    obj.Is_Finance__c =  true;
                    obj.Payment_Type__c='Finance - 36 months';
                   // obj.Status_Update__c = true;
                    obj.SBQQ__SubscriptionTerm__c = 36;
                    obj.Quote_Status_Message__c = 'Client Accepted the Quote with finance, please proceed for Credit Elgibility.';
                    UPDATE obj; 
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Thank you for the Quote Feedback.'));
                }
            } else{
                isSubmitted = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Quote Feedback already submitted.'));
            }
            
            UPDATE obj; 
        }catch(DmlException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDmlMessage(0)));
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        return;        
    }
    
    public void submit()
    {
        if (quotesstatus == 'Rejected'){
            obj.Reason_For_Reject__c = rejectionReason;
            obj.SBQQ__Status__c = 'Client Rejected';
            obj.Status_Update__c = true;
            obj.Quote_Status_Message__c = 'Client Rejected the Quote, please check with Client for Modifications.';
            UPDATE obj;
            isSubmitted = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Thank you for the Quote Feedback.'));
        }
    }
}