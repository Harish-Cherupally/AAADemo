/**
* @author            : Cloud Maven, Inc(support@cloudmaveninc.com)
* @last modified on  : 27-10-2021
**/
public class QuoteTriggerHandler {
    
    public static void onAfterUpdate(List<SBQQ__Quote__c> lstQuotes, Map<Id, SBQQ__Quote__c> mapOldQuotes){
        //createCreditReport(lstQuotes, mapOldQuotes);
    }
    
    /*public static void createCreditReport(List<SBQQ__Quote__c> lstQuotes, Map<Id, SBQQ__Quote__c> mapOldQuotes){
        Map<Id, SBQQ__Quote__c> mapContactQuotes = new Map<Id, SBQQ__Quote__c>();
        List<creditchecker__Credit_Report__c> lstCreditReports = new List<creditchecker__Credit_Report__c>();
        
        for(SBQQ__Quote__c oQuotes : lstQuotes){
            if(oQuotes.Run_Credit_Report__c && (mapOldQuotes.get(oQuotes.Id).Run_Credit_Report__c != oQuotes.Run_Credit_Report__c)){
                mapContactQuotes.put(oQuotes.SBQQ__PrimaryContact__c, oQuotes);
            }
        }
        List<Contact> lstContact = [Select FirstName, LastName, Soc_Security__c, MailingStreet, MailingCity, MailingPostalCode, MailingState, MailingCountry From Contact Where Id In: mapContactQuotes.keySet()];
        for(Contact oContact : lstContact){
            if(!String.isBlank(oContact.FirstName) && !String.isBlank(oContact.LastName) && !String.isBlank(oContact.MailingStreet) && !String.isBlank(oContact.MailingCity) && !String.isBlank(oContact.MailingState) && !String.isBlank(oContact.MailingPostalCode) && !String.isBlank(oContact.MailingCountry) && !String.isBlank(oContact.Soc_Security__c)){
                creditchecker__Credit_Report__c oCreditReport = new creditchecker__Credit_Report__c();
                oCreditReport.creditchecker__Applicants_First_Name__c = oContact.FirstName;
                oCreditReport.creditchecker__Applicants_Last_Name__c = oContact.LastName;
                oCreditReport.creditchecker__Applicants_SSN__c = oContact.Soc_Security__c;
                oCreditReport.creditchecker__Current_Line__c = oContact.MailingStreet;
                oCreditReport.creditchecker__Current_City__c = oContact.MailingCity;
                oCreditReport.creditchecker__Current_StateCode__c = oContact.MailingState;
                oCreditReport.creditchecker__Current_Country__c = oContact.MailingCountry;
                oCreditReport.creditchecker__Current_Zip_Code__c = oContact.MailingPostalCode;
                oCreditReport.creditchecker__Parent_Record_Id__c = mapContactQuotes.get(oContact.Id).Id;
                System.debug('oCreditReport.creditchecker__Parent_Record_Id__c :::>'+oCreditReport.creditchecker__Parent_Record_Id__c);
                System.debug('mapContactQuotes.get(oContact.Id).Id :::>'+mapContactQuotes.get(oContact.Id).Id);
                oCreditReport.Quote__c = mapContactQuotes.get(oContact.Id).Id;
                System.debug('oCreditReport.Quote__c :::>'+oCreditReport.Quote__c);
                lstCreditReports.add(oCreditReport);
            }
            else{
                throw new RequiredFieldMissingException('Missing required field on the Primary Contact, Please Make sure First Name, Last Name, Social Security Number and Full Mailing Address is Populated.');
            }
            
        }
        if(lstCreditReports != null && lstCreditReports.size() > 0){
            insert lstCreditReports;
        }
    }
    public class RequiredFieldMissingException extends Exception{}*/
    
    /* MethodName: updateOppFieldsForPrimaryQuote
     * @params: newQuotes: newly created quotes, oldQuotes: the old data of quote
     * @return: void
     * @Description: This method will update the opportunities field based on primary quote updation
     */
    public static void updateOppFieldsForPrimaryQuote(List<SBQQ__Quote__c> newQuotes,Map<Id,SBQQ__Quote__c> oldQuotes){
        List<Opportunity> updateOpps = new List<Opportunity>();        
        
        for(SBQQ__Quote__c tempQuote :newQuotes){
            if(oldQuotes != null && tempQuote.SBQQ__Status__c != oldQuotes.get(tempQuote.Id).SBQQ__Status__c &&
               tempQuote.SBQQ__Status__c == 'Approved' && tempQuote.SBQQ__Primary__c == true && tempQuote.SBQQ__Opportunity2__c != null){
                Opportunity tempOpp = new Opportunity(Id = tempQuote.SBQQ__Opportunity2__c);
                if(tempQuote.Installation_Type__c != null){
                   tempOpp.Installation_Type__c =  tempQuote.Installation_Type__c;
                }
                tempOpp.Contract_Term__c = tempQuote.SBQQ__SubscriptionTerm__c;
                tempOpp.Original_Total_RMR__c = tempQuote.SBQQ__NetAmount__c;
                tempOpp.Original_Financed_RMR__c = tempQuote.Available_for_Financing_Amount__c;
                tempOpp.New_Total_RMR__c = tempQuote.Equipment_Down_Payment_Amount__c == null ? tempQuote.SBQQ__NetAmount__c : (tempQuote.SBQQ__NetAmount__c - tempQuote.Equipment_Down_Payment_Amount__c);
                tempOpp.New_Financed_RMR__c = tempQuote.Total_Financed_Amount__c;
                tempOpp.Monitoring_RMR__c = tempQuote.Monthly_Monitoring_Amount_NEW__c*12;
                tempOpp.Amount_Paid__c = tempQuote.Equipment_Down_Payment_Amount__c;  
                //tempOpp. = tempQuote.;   
                updateOpps.add(tempOpp);
            }
        }
        
        if(updateOpps.size() > 0){
            update updateOpps;
        }
    }
    
    /*public static void autoSendDocuSign(List<SBQQ__Quote__c> newQuotes,Map<Id,SBQQ__Quote__c> oldQuotes){
        List<String> eligibleQuoteIds = new List<String>();
        for(SBQQ__Quote__c tempQuote :newQuotes){
            if(oldQuotes != null && oldQuotes.containskey(tempQuote.Id) && tempQuote.SBQQ__Status__c == 'Client Accepted' && 
              (tempQuote.Is_Finance__c && tempQuote.Credit_Score_Status__c != oldQuotes.get(tempQuote.Id).Credit_Score_Status__c && tempQuote.Credit_Score_Status__c == 'Approved') 
               ){
                eligibleQuoteIds.add(tempQuote.Id);
            }
        }
        
        if(eligibleQuoteIds.size() > 0){
        	//AutoSendDocuSignEnvelope.sendDocuSignEnvelope(eligibleQuoteIds[0]); 
            System.enqueueJob(new AutoSendDocuSignEnvelope_Queueable(new List<Id>{eligibleQuoteIds[0]}));   
        }        
    }*/    
}