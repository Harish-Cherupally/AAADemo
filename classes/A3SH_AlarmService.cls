public class A3SH_AlarmService {
    
    Public static Organization org = [Select Id,isSandbox from Organization LIMIT 1];   
    
    Public static final string BLANK = '';
    Public static Apigee__mdt apigeeCustomMetadata = Apigee__mdt.getInstance('Apigee_Api_Details_Alarm');
    public static final String authorizationEndpoint = org.IsSandbox ? apigeeCustomMetadata.Test_Authorization_Endpoint__c : apigeeCustomMetadata.Production_Authorization_Endpoint__c;
    Public static final String apigeeEndpoint = org.IsSandbox ? apigeeCustomMetadata.Test_Apigee_Endpoint__c : apigeeCustomMetadata.Production_Apigee_Endpoint__c;
    Public static final String clientId = org.IsSandbox ? apigeeCustomMetadata.Test_Client_Id__c : apigeeCustomMetadata.Production_Client_Id__c;
    Public static final String clientSecret = org.IsSandbox ? apigeeCustomMetadata.Test_Client_Secret__c : apigeeCustomMetadata.Production_Client_Secret__c;
    Public Static String successfulIds;
    Public Static String errorIds;
   
    public static void invokeService(List<Contact> conList){
        try{  
            System.debug('conList=='+ conList);
            System.debug('conList size=='+ conList.size());
            if(!conList.isEmpty()){
                String accsToken = getAccessToken();
                if(String.isNotBlank(accsToken) || Test.isRunningTest()){
                    A3SH_StagesApiRequestBean reqBody = getServiceBean(conList);
                    String ReqJSON =  JSON.serialize(reqBody);
                    getCustomerSysId(ReqJSON,accsToken);
                }    
            } 
             
        }catch (Exception e){
            
        } 
    }
    
    Public static string getAccessToken(){
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
            System.debug('tokenresponse=='+ response);
            if(response.getStatusCode() == 200){
                apigeeTokenResponseWrapper accessTokenWrapper = (apigeeTokenResponseWrapper)JSON.deserialize(response.getBody(), apigeeTokenResponseWrapper.class);
                if(String.isNotBlank(accessTokenWrapper.access_token)){
                    System.debug('accessTokenWrapper=='+ accessTokenWrapper);
                    accessToken = accessTokenWrapper.access_token;
                }
            }
        }catch(Exception ex){}
        return accessToken;
    }
    
    private static void getCustomerSysId(String ReqJSON,String accessToken){
        HttpRequest Req = new HttpRequest();
        Req.setEndpoint(apigeeEndpoint);
        Req.setHeader('Content-Type','application/json');
        Req.setHeader('Authorization','Bearer '+accessToken);
        Req.setTimeout(120000);
        System.debug('ReqJSON=='+ ReqJSON);
        Req.setBody(ReqJSON);
        Req.setMethod('POST');
        
        Http apigeeHttp = new Http();
        try{
            HttpResponse response = apigeeHttp.send(Req);
            System.debug('response=='+ response);
            System.debug('response tostring=='+ response.toString());
            System.debug('response getbody=='+ response.getBody());                                    
            if(response != null &&  response.getStatusCode() == 200){
                A3SH_StagesApiResponseBean responseBean = (A3SH_StagesApiResponseBean) System.JSON.deserialize(response.getBody(), A3SH_StagesApiResponseBean.class); 
                System.debug('responseBean=='+ responseBean);
                if(responseBean != null ){
                    updateContact(responseBean); 
                }
                
            } 
            else if(response != null &&  response.getStatusCode() == 207){
                A3SH_StagesApiResponseBean responseBean = (A3SH_StagesApiResponseBean) System.JSON.deserialize(response.getBody(), A3SH_StagesApiResponseBean.class); 
                System.debug('responseBean=='+ responseBean);
                if(responseBean != null ){
                    updateContact(responseBean); 
                }
                
            }
            else{
                A3SH_StagesApiErrorResponseBean responseBean = (A3SH_StagesApiErrorResponseBean) System.JSON.deserialize(response.getBody(), A3SH_StagesApiErrorResponseBean.class);  
                System.debug('responseBean=='+ responseBean);
            }
            
        }catch(Exception e){}
        
    }
  
    public static void updateContact (A3SH_StagesApiResponseBean resp){
        
        Map<String, Decimal> custbillSysIdMap = new Map<String,Decimal>();
        if(resp != null && resp.customers != null){  
            System.debug('resp0==' + resp);
            System.debug('resp1==' + resp.customers);
            for(A3SH_StagesApiResponseDetailBean res : resp.customers ){
                if(!custbillSysIdMap.containsKey(res.system_id) &&  res.alarm_customer_id != null){
                    custbillSysIdMap.put(res.system_id, res.alarm_customer_id);
                    successfulIds = res.billing_id;  
                        System.debug('successfulIds=='+ successfulIds);
                }else if(res.alarm_customer_id == null){
                     errorIds = res.billing_id;
                    System.debug('errorIds=='+ errorIds);
                }
            }  
        }
        
        // Get list of contact IDs that were successfully processed at Alarm.com
        List<asset> assets = [SELECT ContactId FROM Asset WHERE Type__c = 'Customer Systems' AND Alarm__c IN : custbillSysIdMap.keySet()];
        List<Id> conIds = new List<Id>();
      
        for(asset a : assets){
            if(!conIds.contains(a.ContactId)){
                conIds.add(a.ContactId);
            }
        }
       
        List<Contact> updContact = new List<Contact>();
        for(contact co : [SELECT Id, Alarm__c FROM Contact Where Id In: conIds]){
            co.Alarm__c = true;
            if(!updContact.contains(co)){
              updContact.add(co);  
            }   
        }
        update updContact;
         
    }
    
    public class apigeeTokenResponseWrapper{
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
    
    public static A3SH_StagesApiRequestBean getServiceBean(List<contact> con){
        
        A3SH_StagesApiRequestBean reqDetBean = new A3SH_StagesApiRequestBean(); 
        List<A3SH_StagesApiRequestDetailBean> reqList = new List<A3SH_StagesApiRequestDetailBean>();
        Map<Id, String> conCustIdMap = new Map<Id,String>();
         Map<Id, String> conprdCodeMap = new Map<Id,String>();
        for(Customer_Systems__c cs : [SELECT Id, Alaram__c, Customer__c FROM Customer_Systems__c WHERE Customer__c IN: con ]){
            if(!conCustIdMap.containsKey(cs.Customer__c)){
                conCustIdMap.put(cs.Customer__c, cs.Alaram__c);
            }   
        }
        for(OpportunityLineItem opptyline : [SELECT Id,Contact__c, Product2Id,Product2.Sedona_Product_ID__c FROM OpportunityLineItem WHERE Contact__c IN: con ]){
            System.debug('opptyline.Product2.Sedona_Product_ID__c=='+ opptyline.Product2.Sedona_Product_ID__c);
            if(opptyline.Product2.Sedona_Product_ID__c == '447' || opptyline.Product2.Sedona_Product_ID__c == '448' || opptyline.Product2.Sedona_Product_ID__c == '535'){
                System.debug('opptyline.Product2.Sedona_Product_ID__c=='+ opptyline.Product2.Sedona_Product_ID__c);
                if(!conprdCodeMap.containsKey(opptyline.Contact__c)){
                conprdCodeMap.put(opptyline.Contact__c , 'Smart');
            }    
            }else if(opptyline.Product2.Sedona_Product_ID__c == '441'){
                 System.debug('opptyline.Product2.Sedona_Product_ID__c=='+ opptyline.Product2.Sedona_Product_ID__c);
                if(!conprdCodeMap.containsKey(opptyline.Contact__c)){
                conprdCodeMap.put(opptyline.Contact__c , 'Basic');
            }  
                
            }
        }
        System.debug('conprdCodeMap=='+ conprdCodeMap);
        
        // Get addresses from first site account
        Set<Id> AccountIds = new Set<Id>();														
        for (contact cont : con) {
               AccountIds.add(cont.AccountId); 
        }	 
        
        List<account> siteList = [SELECT ParentId, Name, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, Phone, CreatedDate 
                                  FROM Account
                                  WHERE ParentId IN : AccountIds];
        
        Map<Id, account> siteMap = new Map<Id, account>();
        
        // Add first site (based on earliest CreatedDate) for each ParentId to siteMap
        for (account a : siteList) {
            if (!siteMap.containsKey(a.ParentId) || a.CreatedDate < siteMap.get(a.ParentId).CreatedDate) {
                siteMap.put(a.ParentId, a);
            }
        }
        
        for(contact cont : con){
            if(siteMap.containsKey(cont.AccountId)) {
                A3SH_StagesApiRequestDetailBean req = new A3SH_StagesApiRequestDetailBean();
            	
                // Get site account
            	account a = siteMap.get(cont.AccountId);
                
             // req.site_name = cont.Name;
                req.first_name = cont.FirstName;
                req.last_name = cont.LastName;
            	req.address = a.ShippingStreet;
            	req.address2 = null;
            	req.city = a.ShippingCity;
            	req.state = a.ShippingState;
            	req.zip_code = a.ShippingPostalCode;
                req.type = cont.CustomerType__c;
                req.billing_id =  cont.CustomerNumber__c;
                req.phone_number = a.Phone;
                req.email_address = cont.Email;
                req.type = cont.CustomerType__c;
                if(conCustIdMap.containsKey(cont.Id)){
                    req.system_id = conCustIdMap.get(cont.Id);
                }else{
                    req.system_id = '';  
                }
                if(conprdCodeMap.containsKey(cont.Id)){
                    req.item_code =  conprdCodeMap.get(cont.Id);
                }else{
                    req.item_code =  '';  
                }
                if(req != null){
                    reqList.add(req);  
                }                  
            }
                
        }
        reqDetBean.customers = reqList;
        return reqDetBean;
        
    }

}