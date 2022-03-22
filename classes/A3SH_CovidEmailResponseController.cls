/**********************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/25/2021
* @Description   : This apex class is the controller class for A3SH_CovidEmailResponse. This is used
				   for covid response tracking and storing in the fields in the service appointment record
************************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
******************************************************************************************************
1. 
**********************************************************************************************************/
public without sharing class A3SH_CovidEmailResponseController {

    public String serviceAppointmentId {get;set;}
    public string serviceAppointmentEncryptedId{get;set;}
    public string selectedValue{get;set;}
    public Boolean isSelectedYes{get;set;}
    public string moreDetails{get;set;}
    public Boolean detailsSubmitted{get;set;}
    public ServiceAppointment sa{get;set;}
    public Boolean submittedBefore{get;set;}
    public Boolean notValidURL{get;set;}
    private static final string SAID = 'saId';
    private static final string SPACE = ' ';
    private static final string PLUS = '+';
    private static final string AES128 = 'AES128';
    private static final string SAID_PREFIX = '08p';
    public string contactName {get;set;}
    public string street {get;set;}
    public string city {get;set;}
    public string state {get;set;}
    public string postalcode {get;set;}
    public string workordernumber {get;set;}
    public string urlValue {get;set;}
    /****************************************************************************************************************
     * @Description : Controller for the class which is retrieving the ecnrypted service appointment id and 
     * 				  decrypting the value. Checking conditions whether the Customer has already provided the Covid
     * 				  details or not. Throw an error if any user is accessing incorrect URL.
     * *************************************************************************************************************/
    public A3SH_CovidEmailResponseController(){
        urlValue = URL.getCurrentRequestUrl().toExternalForm();
        serviceAppointmentEncryptedId = String.valueOf(apexpages.currentpage().getparameters().get(SAID));
        String isSuccess = String.valueOf(apexpages.currentpage().getparameters().get('success'));
        if(String.isNotBlank(serviceAppointmentEncryptedId)){
            serviceAppointmentEncryptedId = serviceAppointmentEncryptedId.replaceAll(SPACE,PLUS);
        }
        Blob key = Blob.valueOf(System.Label.A3SH_CryptoKey);
        Blob decryptedData = Crypto.decryptWithManagedIV(AES128,key,EncodingUtil.base64Decode(serviceAppointmentEncryptedId));
        serviceAppointmentId = decryptedData.toString();
        if(String.isNotBlank(serviceAppointmentId) && serviceAppointmentId.startsWith(SAID_PREFIX)){
            sa = [Select Id,Covid_ve_Symptoms_Close_Contact__c,Contact_Full_Name__c,Work_Order_Number__c,Contact.MailingStreet,Contact.MailingCity,Contact.MailingState,Contact.MailingPostalCode from ServiceAppointment Where Id=:serviceAppointmentId limit 1];
            contactName = sa.Contact_Full_Name__c;
            street = sa.Contact.MailingStreet;
            city = sa.Contact.MailingCity;
            state = sa.Contact.MailingState;
            postalcode = sa.Contact.MailingPostalCode;
            workordernumber = sa.Work_Order_Number__c;
            if(String.isNotBlank(isSuccess) && 'true'.equalsIgnoreCase(isSuccess)){
                submittedBefore = true;ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Thank you for submitting the details.'));
            }
            else if('Yes'.equalsIgnoreCase(sa.Covid_ve_Symptoms_Close_Contact__c) || 'No'.equalsIgnoreCase(sa.Covid_ve_Symptoms_Close_Contact__c)){
                submittedBefore = true; ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Details have already been submitted for this Service Appointment. Thank you.'));
            }
        }else{
            notValidURL = true; ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Not a valid URL'));
        }
    }
    /*******************************************************************************************************
     * @Description : Method is to construct the selectable items list with Yes/No values.
     * @Return Type : List<SelectOption>
     * *****************************************************************************************************/
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }
    /*******************************************************************************************************
     * @Description : Method is take the user input and update the details on service appointment record.
     * 				  It checks whether the customer has provided the mandatory information or not. Else,
     * 				  It will throw an error and ask for the details to be submitted.
     * @Return Type : PageReference
     * *****************************************************************************************************/
    public PageReference submitDetails() {
        
        if(String.isBlank(selectedValue)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the option.'));
        }else if('Yes'.equalsIgnoreCase(selectedValue) && String.isBlank(moreDetails)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide more details on the covid status.'));
        }else{
            ServiceAppointment saObj = new ServiceAppointment(Id=serviceAppointmentId,Covid_ve_Symptoms_Close_Contact__c = selectedValue , Covid_ve_Symptoms_Close_Contact_Details__c = moreDetails);
            update saObj;
            detailsSubmitted = true;
            PageReference pageRef = new PageReference(urlValue+'&success=true');
            pageRef.setRedirect(true);
            return pageRef; 
        }
           
		return null;
    }
    /*******************************************************************************************************
     * @Description : Method is to track the selected value based on the user selection on visualforce page
     * @Return Type : void
     * *****************************************************************************************************/
    public void updateSelectedValue(){
        if('Yes'.equalsIgnoreCase(selectedValue)){
            isSelectedYes = true;
        }else if('No'.equalsIgnoreCase(selectedValue)){
            isSelectedYes = false;
        }
    }
    
}