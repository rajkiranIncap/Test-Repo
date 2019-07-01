/**
* This test class is used to cover the code for PopulatePicklist class, this class
* help to send the response as mock response because the test method are not allowed
* to call out external service..
*
* @Author Incapsulate
* @Since 25/02/2019
*/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement HttpCalloutMock interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"values":[{"label":"Propect","value":"Propect"}]}');
        res.setStatusCode(200);
        return res;
    }
}