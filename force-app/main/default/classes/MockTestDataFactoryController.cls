@IsTest
public with sharing class MockTestDataFactoryController {
    public static Task createTasks(String subject, date dueDate, 
                                                    String priority, Id locationId) {
        Task taskRec = new Task();
        taskRec.Subject = subject;
        taskRec.ActivityDate= dueDate;
        taskRec.Priority = priority;  
        taskRec.WhatId = locationId;
        return taskRec;
    }

    public static Account createAccount(String name, String phoneNo, String type) {
        //Create Account
        Account a = new Account();
        a.Name = name ;                                  
        a.Phone = phoneNo;     
        a.Type = type;                                                  
        return a;
    }

    public static EPP_Test_RAD__Location__c createSalesChannel(String cityName, String countryName) {

        EPP_Test_RAD__Location__c location = new EPP_Test_RAD__Location__c();
        location.EPP_Test_RAD__City__c = cityName;  
        location.EPP_Test_RAD__Country__c   =   countryName;                                          
        return location;
    }
}