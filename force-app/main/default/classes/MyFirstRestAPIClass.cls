@RestResource(urlMapping='/api/Account/*')
global without sharing class MyFirstRestAPIClass
{
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        System.debug('req ***'+req );
        RestResponse res = RestContext.response;
        System.debug('res ***'+res );
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug('AccNumber ***'+AccNumber );
        Account result = [SELECT Id, Name, Phone, Website FROM Account WHERE AccountNumber = :AccNumber ];
        res.responseBody = Blob.valueOf('accepted');
        res.statusCode = 200;
        //return result;
    }

    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name, Phone, Website FROM Account WHERE AccountNumber = :AccNumber ];
        delete result;
    }

   @HttpPost
    global static void doPost() {       
        System.debug('Method called doPost***');
        RestRequest req = RestContext.request;
        System.debug('req ***'+req );
         System.debug('req headers ***'+req.headers.get('Authorization') );
        String content = RestContext.request.requestBody.toString();
        System.debug('content ***'+content );
        String receivedHmacSignature = RestContext.request.headers.get('hmacSignature');
        System.debug('receivedHmacSignature ***'+receivedHmacSignature);
        RestResponse res = RestContext.response;
        System.debug('res ***'+res );
        String requestresult = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug('requestresult ***'+requestresult );
        res.responseBody = Blob.valueOf('[accepted]');
        res.statusCode = 200;
        System.debug('res***'+res);
        
    }

}