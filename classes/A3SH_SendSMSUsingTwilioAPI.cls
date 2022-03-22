/**********************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/23/2021
* @Description   : This apex class is used to send the text message to customer whenever a task is created.
* 				   This class is calling from Task Trigger
******************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
******************************************************************************************************
1. 
**********************************************************************************************************/
public class A3SH_SendSMSUsingTwilioAPI {
    
    private static final string BLANK = '';
    private static final string WORKORDER_NUMBER = '##WORKORDER_NUMBER##';
    private static final string SCHEDULE_START_TIME = '##SCHEDULE_START_TIME##';
    
    private static Twillio_API_Details__mdt twillioCustomMetadata = Twillio_API_Details__mdt.getInstance('Twillio_API');
    private static Organization org = [Select Id,isSandbox from Organization LIMIT 1];
    private static final String authorizationEndpoint = org.IsSandbox ? twillioCustomMetadata.Test_Authorization_Endpoint__c : twillioCustomMetadata.Production_Authorization_Endpoint__c;
    private static final String smsEndpoint = org.IsSandbox ? twillioCustomMetadata.Test_SMS_Endpoint__c : twillioCustomMetadata.Production_SMS_Endpoint__c;
    private static final String clientId = org.IsSandbox ? twillioCustomMetadata.Test_Client_Id__c : twillioCustomMetadata.Production_Client_Id__c;
    private static final String clientSecret = org.IsSandbox ? twillioCustomMetadata.Test_Client_Secret__c : twillioCustomMetadata.Production_Client_Secret__c;
    private static final string TEST_MESSAGE = org.IsSandbox ? 'TEST_MESSAGE' : ' A3SH_INSTALLATION_REMINDER';
    /**********************************************************************************************************************
* @Method Name : sendSMS
* @Parameters  : Id taskId
* @Description : This method is a future method is calling from Task trigger to send the SMS if the task is created 
* 				  for Service Appointment record.The message will sent only on specific automated task creation. 
* 				  The subjects are mentioned in the custom metadata
* *********************************************************************************************************************/
    @future(callout=true)
    public static void sendSMS(Id taskId)
    {
        Integer limitTaskRecords = Limits.getLimitQueries() - Limits.getQueries();
        Map<Id,Task> taskMap = new Map<Id,Task>([SELECT Id,WhatId,Subject FROM Task WHERE ID =:taskId LIMIT :limitTaskRecords]);
        
        Set<Id> serviceAppointmentIds = new Set<Id>();
        for(Task taskObj : taskMap.values()){
            serviceAppointmentIds.add(taskObj.whatId);
        }
        Integer limitSARecords = Limits.getLimitQueries() - Limits.getQueries();
        Map<Id,ServiceAppointment> serviceAppointmentMap = new Map<Id,ServiceAppointment>([SELECT Id,AppointmentNumber,ContactId,Contact.FirstName,Contact.Phone,Work_Order_Number__c,
                                                                                           SchedStartTime,Scheduled_Start_Time_Window_Start__c,Scheduled_Start_Time_Window_End__c
                                                                                           FROM ServiceAppointment WHERE ID IN :serviceAppointmentIds
                                                                                           AND Contact.Phone != null 
                                                                                           LIMIT :limitSARecords]);
        
        Map<String,String> subjectMsgMap = new Map<String,String>();
        Map<String,ReminderSMSSubject_Message__mdt> reminderSMSSubjectMdtMap = ReminderSMSSubject_Message__mdt.getAll();
        for(ReminderSMSSubject_Message__mdt reminderSMSMdt : reminderSMSSubjectMdtMap.values()){
            subjectMsgMap.put(reminderSMSMdt.Task_Subject__c,reminderSMSMdt.Reminder_Message__c);
        }
        A3SH_SENDSMS a3shSendSMS = null;
        for(Task taskObj : taskMap.values()){
            if(taskObj.Subject != null && subjectMsgMap.containsKey(taskObj.Subject)){
                ServiceAppointment saRecord = serviceAppointmentMap.get(taskObj.WhatId);
                
                if(saRecord != null && saRecord.contactId != null && saRecord.contact.phone != null){ 
                    
                    String finalMsg = subjectMsgMap.get(taskObj.Subject);
                    
                    if(finalMsg.contains(WORKORDER_NUMBER) && saRecord.Work_Order_Number__c != null){
                       finalMsg = finalMsg.replace(WORKORDER_NUMBER,saRecord.Work_Order_Number__c); 
                    }
                    if(finalMsg.contains(SCHEDULE_START_TIME) && saRecord.SchedStartTime != null){
                        DateTime twoHrsAfterTime = saRecord.SchedStartTime.addHours(2);
                        finalMsg = finalMsg.replace(SCHEDULE_START_TIME,saRecord.SchedStartTime.format('MM/dd/yyyy hh:mm a')+' - '+twoHrsAfterTime.format('hh:mm a'));  
                    }
                    a3shSendSMS = new A3SH_SENDSMS(TEST_MESSAGE,saRecord.contact.phone,finalMsg); 
                }
            }
        }
        String sendSMSReqJSON = BLANK;
        if(a3shSendSMS != null){
            sendSMSReqJSON = JSON.serialize(a3shSendSMS);
        }
        if(String.isNotBlank(sendSMSReqJSON)){
            String accessToken = getAccessToken();
            if(String.isNotBlank(accessToken)){
                sendSMSUsingTwilioAPI(sendSMSReqJSON,accessToken);
            }
        }        
    }
    /***********************************************************************************
*@Description : A3SH_SENDSMS is the wrapper class for sending the text sms
* *******************************************************************************/
    public class A3SH_SENDSMS{
        public string type;
        public string to;
        public string body;
        public A3SH_SENDSMS(string type,string to,string body){
            this.type = type;
            this.to = to;
            this.body = body;
        }
    }
    /***********************************************************************************
* @Description : Method to send the sms using twilio end point
* @Parameters  : String sendSMSReqJSON,String accessToken
* @Return Type : void
* *******************************************************************************/
    private static void sendSMSUsingTwilioAPI(String sendSMSReqJSON,String accessToken){
        HttpRequest sendSMSReq = new HttpRequest();
        sendSMSReq.setEndpoint(smsEndpoint);
        sendSMSReq.setHeader('Content-Type','application/json');
        sendSMSReq.setHeader('Authorization','Bearer '+accessToken);
        sendSMSReq.setBody(sendSMSReqJSON);
        sendSMSReq.setMethod('POST');
        
        Http sendSMSHttp = new Http();
        try{
            HttpResponse sendResponse = sendSMSHttp.send(sendSMSReq);
        }catch(Exception e){}
        
    }
    /****************************************************************************************
* @Description : Method to get the access token using the Client_Id and Client_Password
* @Parameters  : 
* @Return Type : void
* **************************************************************************************/
    private static string getAccessToken(){
        String accessToken = BLANK;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(authorizationEndpoint);
        String payLoad = 'grant_type=client_credentials' 
            + '&client_id=' + EncodingUtil.urlEncode(clientId,'UTF-8') 
            + '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8');
        req.setBody(payLoad);
        req.setMethod('POST');
        Http http = new Http();
        try{
            HttpResponse response = http.send(req);
            if(response.getStatusCode() == 200){
                A3SH_TwilioAccessTokenResponseWrapper accessTokenWrapper = (A3SH_TwilioAccessTokenResponseWrapper)JSON.deserialize(response.getBody(), A3SH_TwilioAccessTokenResponseWrapper.class);
                if(String.isNotBlank(accessTokenWrapper.access_token)){
                    accessToken = accessTokenWrapper.access_token;
                }
            }
        }catch(Exception ex){}
        return accessToken;
    }
    /****************************************************************************************
* @Description : Wrapper class for parsing the authorization token response
* **************************************************************************************/
    public class A3SH_TwilioAccessTokenResponseWrapper{
        public String refresh_token_expires_in;
        public String api_product_list;
        public List<String> api_product_list_json;
        public String organization_name;
        public String token_type;
        public String issued_at;
        public String client_id;
        public String access_token;
        public String application_name;
        public String scope;
        public String expires_in;
        public String refresh_count;
        public String status;
    }
}