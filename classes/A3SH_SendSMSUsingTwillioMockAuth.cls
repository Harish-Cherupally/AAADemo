/*******************************************************************************************************************************
* @Author        : Bhaskar Bellapu(Accenture)
* @Created Date  : 03/31/2021
* @Description   : This apex class is Mock Response class for A3SH_SendSMSUsingTwillioAPI
*********************************************************************************************************************************
Change History    Version      ||    Modified By    ||  Modification Date        ||    Description
***************************************************************************************************************************
1. 
*******************************************************************************************************************************/
@isTest
global class A3SH_SendSMSUsingTwillioMockAuth implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
       
        // Create a test response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{ "refresh_token_expires_in": "0",    "api_product_list": "[SMS]",    "api_product_list_json": [        "SMS"    ],    "organization_name": "goaaa-preprod",    "token_type": "Bearer",    "issued_at": "1617185173951",    "client_id": "utFaMJNJEqZ2ITv5H3edrLEl6OB3LUF1",    "access_token": "LEpiyxA5MKKPW5VCyxc3mFZmupvs",    "application_name": "5540127c-bdcc-4cb6-9a42-0ea855ebdbfe",    "scope": "",    "expires_in": "599",    "refresh_count": "0",    "status": "approved"}');
        res.setStatusCode(200);
        return res;
    }
}