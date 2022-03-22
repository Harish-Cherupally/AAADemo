public class A3SH_StagesService {
    
    Public static Organization org = [Select Id,isSandbox from Organization LIMIT 1];   
    
    Public static final string BLANK = '';
    Public static Apigee__mdt apigeeCustomMetadata = Apigee__mdt.getInstance('Apigee_Api_Details_Stages');
    public static final String authorizationEndpoint = org.IsSandbox ? apigeeCustomMetadata.Test_Authorization_Endpoint__c : apigeeCustomMetadata.Production_Authorization_Endpoint__c;
    Public static final String apigeeEndpoint = org.IsSandbox ? apigeeCustomMetadata.Test_Apigee_Endpoint__c : apigeeCustomMetadata.Production_Apigee_Endpoint__c;
    Public static final String clientId = org.IsSandbox ? apigeeCustomMetadata.Test_Client_Id__c : apigeeCustomMetadata.Production_Client_Id__c;
    Public static final String clientSecret = org.IsSandbox ? apigeeCustomMetadata.Test_Client_Secret__c : apigeeCustomMetadata.Production_Client_Secret__c;
    Public Static String successfulIds;
    Public Static String errorIds;
    
    // Map to store site accounts
    Static Map<Id, account> siteMap;
    
    public static void invokeService(List<Contact> conList){
        try{  
            System.debug('conList=='+ conList);
            if(!conList.isEmpty()){
                String accsToken = getAccessToken();
                if(String.isNotBlank(accsToken) || Test.isRunningTest()){
                    loadSiteAccounts(conList);
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
                updErrorObj(responseBean);
            }
            
        }catch(Exception e){}
        
    }
    
    public static void updErrorObj(A3SH_StagesApiErrorResponseBean clErr){
        
    }
    
    public static void updateContact (A3SH_StagesApiResponseBean resp){
        
        Map<String, String> custbillSysIdMap = new Map<String,String>();
        
        if(resp != null && resp.customers != null){  
            System.debug('resp0==' + resp);
            System.debug('resp1==' + resp.customers);
            for(A3SH_StagesApiResponseDetailBean res : resp.customers ){
                if(!custbillSysIdMap.containsKey(res.billing_id) &&  res.system_id != null){
                    custbillSysIdMap.put(res.billing_id, res.system_id);
                        successfulIds = res.billing_id;  
                }else if(res.system_id == null){
                    errorIds = res.billing_id;
                }
            }  
        }
                
        List<Customer_Systems__c> insCusSystem = new List<Customer_Systems__c>();
        List<Asset> insAsset = new List<Asset>();
        List<Id> conIds = new List<Id>();
        
        for(contact con : [SELECT Id, CustomerNumber__c, AccountId FROM Contact WHERE CustomerNumber__c IN : custbillSysIdMap.keySet()]){
            
            if(!conIds.contains(con.Id)){
                conIds.add(con.Id);
            }
            
            // Create Customer Systems record
            Customer_Systems__c cusObj = new Customer_Systems__c(); 
            cusObj.Customer__c = con.Id;
            if(custbillSysIdMap.containsKey(con.CustomerNumber__c)){
                cusObj.Alaram__c = custbillSysIdMap.get(con.CustomerNumber__c);  
                cusObj.Panel_Type__c = 'Qolsys2';
                cusObj.Name = 'Customer -' + custbillSysIdMap.get(con.CustomerNumber__c);
            }
            if(cusObj.Alaram__c != null){
                insCusSystem.add(cusObj);  
            }
            
            // Create Asset record
            Asset a = new Asset();
            a.Name = 'Customer Systems ' + siteMap.get(con.AccountId).Name + ' ' + System.now();
            a.Type__c = 'Customer Systems';
            a.AccountId = siteMap.get(con.AccountId).Id;
            a.ContactId = con.Id;
            a.Alarm__c = custbillSysIdMap.get(con.CustomerNumber__c);
            a.Panel_Type__c = 'Qolsys2';
            
            if(a.Alarm__c != null){
                insAsset.add(a);  
            }
        } 
        
        insert insCusSystem;
        insert insAsset;
       
        List<Contact> updContact = new List<Contact>();
        for(contact co : [SELECT Id,Stages__c FROM Contact Where Id In: conIds]){
            co.Stages__c = true;
            if(!updContact.contains(co)){
              updContact.add(co);  
            }   
        }
        update updContact;
    }
    
    public static void loadSiteAccounts(List<contact> con){
        Set<Id> AccountIds = new Set<Id>();				
        
        // Get all parent accounts
        for (contact cont : con) {
               AccountIds.add(cont.AccountId); 
        }	 
        
        List<account> siteList = [SELECT ParentId, Name, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, Phone, CreatedDate 
                                  FROM Account
                                  WHERE ParentId IN : AccountIds];
        
        siteMap = new Map<Id, account>();
        
        // Add first site (based on earliest CreatedDate) for each ParentId to siteMap
        for (account a : siteList) {
            if (!siteMap.containsKey(a.ParentId) || a.CreatedDate < siteMap.get(a.ParentId).CreatedDate) {
                siteMap.put(a.ParentId, a);
            }
        }
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
                
            	req.site_name = a.Name;
            	req.address = a.ShippingStreet;
            	req.address2 = null;
            	req.city = a.ShippingCity;
            	req.state = a.ShippingState;
            	req.zip_code = a.ShippingPostalCode;
            	req.billing_id =  cont.CustomerNumber__c;
            	req.phone_number = a.Phone;
            	req.email_address = cont.Email;
            	req.type = cont.CustomerType__c;
	            
	            if(req != null){
	                reqList.add(req);  
	            }    
            }  
        }
        reqDetBean.customers = reqList;
        return reqDetBean;
        
    }
}