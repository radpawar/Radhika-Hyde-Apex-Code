/******************************************************************************************
 *  Date          : 22 Aug-2024
 *  Author        : Radhika Pawar
 *  Description   : list of tasks assigned to the current user
 *                  Create a task and update a task
 *                  retrived picklist values
 *                  
 * 
 * Modifications  : 
 * ***************************************************************************************/

public with sharing class TaskManagerController {
   
    @AuraEnabled
    public static List<Task> getTaskDetails() {
        List<Task> activityRecords = new List<Task>();
        activityRecords = [SELECT  Id, WhoId, WhatId, Subject, ActivityDate, Status, Priority, OwnerId ,CompletedDateTime
                            FROM Task
                            WHERE OwnerId=: UserInfo.getUserId()];
        
        return activityRecords;
    }
    
    @AuraEnabled
    public static void createTaskRecordInfo(String subject, Date dueDate, String priority) {
        try {
            Account acc = new Account();
            acc = [Select Id FROM Account limit 1];
            EPP_Test_RAD__Location__c location = new EPP_Test_RAD__Location__c();
            location = [Select Id FROM EPP_Test_RAD__Location__c limit 1];
            
            Task taskRec = new Task();
            taskRec.Subject = subject;
            taskRec.ActivityDate= dueDate;
            taskRec.Priority = priority;  
            taskRec.WhatId = location !=null ?location.Id :  acc.Id;            
            insert taskRec;            
            
        }
        catch(exception ex){
        system.debug('Error***'+ex);
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String,String> retrievePickListFields(String fieldApiName) {
        Map<String, String> fInfo = new Map<String, String>();
        String objectName = 'Task';
        String fieldName = fieldApiName;
        
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe() ;
        Map<String,Schema.SObjectField> fields = objDescribeSobject.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());        
            fInfo.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        
        System.debug(fInfo+'fInfo*** ');
        return fInfo;
    }
    
    @AuraEnabled
    public static void updateTaskDetails(List<Task> taskRecords) {
        System.debug('taskRecords*** '+taskRecords);
        if(!taskRecords.isempty()) {
            update taskRecords;
        }    
    }
    
    
    
}