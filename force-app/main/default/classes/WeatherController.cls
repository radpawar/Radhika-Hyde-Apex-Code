/******************************************************************************************
 *  Date          : 11 Sep
 *  Author        : Radhika Pawar
 *  Description   : Retrived weather details which you have recived
 *                  
 * 
 * Modifications  : 
 * ***************************************************************************************/

public with sharing class WeatherController {
    
    /**
     * @description This method called from lightning component for wired method
     * @param locationId
     * @return EPP_Test_RAD__Weather__c
     */
    @AuraEnabled(cacheable=true)
    public static EPP_Test_RAD__Weather__c getWeatherDetails(Id locationId){
        EPP_Test_RAD__Weather__c weatherDetails = new EPP_Test_RAD__Weather__c();
        weatherDetails = [SELECT Id, EPP_Test_RAD__Locations__c, EPP_Test_RAD__Description__c, EPP_Test_RAD__humidity__c,
                            EPP_Test_RAD__Temp__c, EPP_Test_RAD__Temp_Max__c, EPP_Test_RAD__Temp_Min__c, 
                            EPP_Test_RAD__Wind_Speed__c 
                            FROM EPP_Test_RAD__Weather__c 
                            WHERE EPP_Test_RAD__Locations__c=: locationId 
                            Limit 1  ];        
        return weatherDetails;
    }

    /**
     * @description This method called from lightning component once click on refresh button
     * @param locationId
     */
     @AuraEnabled
    public static void getWeatherFromRefershButton(Id locationId) {
        EPP_Test_RAD__Weather__c weatherDetails = new EPP_Test_RAD__Weather__c();
        Map<EPP_Test_RAD__Location__c, WeatherHelperController.WeatherResponseWrapperClass> weatherResponseMap = new Map<EPP_Test_RAD__Location__c, WeatherHelperController.WeatherResponseWrapperClass>();

        try {
            EPP_Test_RAD__Location__c locationParam = [SELECT Id, EPP_Test_RAD__City__c, (Select Id from EPP_Test_RAD__Weather__r) 
                                                    FROM EPP_Test_RAD__Location__c 
                                                    WHERE Id = : locationId
                                                    WITH SYSTEM_MODE 
                                                    ORDER BY CreatedDate DESC ];
        
            WeatherHelperController.getWeatherDetails(locationParam, weatherResponseMap);
            WeatherHelperController.updateWeatherInfo(weatherResponseMap);
        }catch (Exception Ex) {
            
           ExceptionLogsUtility.createExceptionLog(Ex.getStackTraceString(), Ex.getLineNumber(), Ex.getMessage(), Ex.getTypeName(), '', Ex.getStackTraceString());
           throw new WeatherHelperController.WeatherDetailsException(
                'Couldn\'t update Location with ID ' + locationId
           );
        }        
    }
}