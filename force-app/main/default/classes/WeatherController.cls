/******************************************************************************************
 *  Date          : 21 Aug-2024
 *  Author        : Radhika Pawar
 *  Description   : Retrived weather details which you have recived
 *                  
 * 
 * Modifications  : 
 * ***************************************************************************************/

public with sharing class WeatherController {
    @AuraEnabled(cacheable=true)
    public static EPP_Test_RAD__Weather__c getWeatherDetails(Id locationId){
        System.debug('locationId***'+locationId);
        EPP_Test_RAD__Weather__c weatherDetails = new EPP_Test_RAD__Weather__c();
        weatherDetails = [SELECT Id, EPP_Test_RAD__Locations__c, EPP_Test_RAD__Description__c, EPP_Test_RAD__humidity__c,
                            EPP_Test_RAD__Temp__c, EPP_Test_RAD__Temp_Max__c, EPP_Test_RAD__Temp_Min__c, 
                            EPP_Test_RAD__Wind_Speed__c FROM EPP_Test_RAD__Weather__c 
                            WHERE EPP_Test_RAD__Locations__c=: locationId 
                            Limit 1  ];
        System.debug('weatherDetails***'+weatherDetails);
        return weatherDetails;
    }

}