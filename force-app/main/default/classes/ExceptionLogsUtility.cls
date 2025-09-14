/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @Author         Radhika
* @Class          ExceptionLogUtility
* @Description   Handle Exception
* ──────────────────────────────────────────────────────────────────────────────────────────────────
*/

public with sharing class ExceptionLogsUtility {
    public static void createExceptionLog(String apexClassName, Integer exceptionLine, String exceptionMesg, String exceptionType, String inputParams, String methodName){
       
        EPP_Test_RAD__exception_log__c el = new EPP_Test_RAD__exception_log__c(
        EPP_Test_RAD__ExceptionMessage__c = exceptionMesg, 
        EPP_Test_RAD__ExceptionLine__c = exceptionLine,
        EPP_Test_RAD__ExceptionType__c = exceptionType, 
        EPP_Test_RAD__ApexClassName__c = apexClassName.substringBefore(':').substringBeforeLast('.'),
        EPP_Test_RAD__MethodName__c = methodName.substringBefore(':').substringAfterLast('.'));
        insert as system el;
    }
}
