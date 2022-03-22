@isTest
global class A3SH_StagesMockErrrorAuth implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
       
        // Create a test response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"error" :"errorService"}');
        res.setStatusCode(500);
        return res;
    }

}