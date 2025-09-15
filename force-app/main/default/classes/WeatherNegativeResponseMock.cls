@isTest
global with sharing class WeatherNegativeResponseMock implements HttpCalloutMock {
     global HTTPResponse respond(HTTPRequest request) {
        String json=		'{'+
		'    "cod": "404",'+
		'    "message": "city not found"'+
		'}';
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(json);
        response.setStatusCode(404);
        return response; 
    }
}
