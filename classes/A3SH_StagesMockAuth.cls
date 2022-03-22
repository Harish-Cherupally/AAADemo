@isTest
global class A3SH_StagesMockAuth implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
       
        // Create a test response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"customers" : [{ "billing_id": "121123","system_id": "13121121" } ]}');
        res.setStatusCode(200);
        return res;
    }
}