/**
 * ─────────────────────────────────────────────────────────────────────────────────────────────────
 * @class          WeatherBatchController
 * @TestClass      WeatherBatchController
 * @description    Handle High volumn of data
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 */
 
public with sharing class WeatherBatchController implements Database.Batchable<SObject>, Database.AllowsCallouts{
/**
     * @description standard start method
     * @param bc
     * @return Database.QueryLocator
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = ' SELECT Id, EPP_Test_RAD__City__c, EPP_Test_RAD__CityId__c, EPP_Test_RAD__WeatherRecordCount__c, '+
                       ' EPP_Test_RAD__JSON_Response_Body__c, EPP_Test_RAD__Response_code__c, EPP_Test_RAD__Location__c, '+
                       ' (Select Id from EPP_Test_RAD__Weather__r) '+ 
                       ' FROM EPP_Test_RAD__Location__c '+
                       ' WITH SYSTEM_MODE '+
                       ' ORDER BY CreatedDate DESC ' ;
        
        return Database.getQueryLocator(query);
    }
    /**
     * @description standard execute method
     * @param bc
     * @param locationRecords List of location Records to process
     */
    public void execute(Database.BatchableContext bc, List<EPP_Test_RAD__Location__c> locationRecords) {
        Map<EPP_Test_RAD__Location__c, WeatherHelperController.WeatherResponseWrapperClass> weatherResponseMap = new Map<EPP_Test_RAD__Location__c, WeatherHelperController.WeatherResponseWrapperClass>(); 
       
        for(EPP_Test_RAD__Location__c locationParam : locationRecords) {
            weatherResponseMap.put(locationParam, new  WeatherHelperController.WeatherResponseWrapperClass());
            WeatherHelperController.getWeatherDetails(locationParam, weatherResponseMap);
        }

        WeatherHelperController.updateWeatherInfo(weatherResponseMap);

    }

    /**
     * @description standard finish method
     * @param bc
     */
    public void finish(Database.BatchableContext bc) {
    
    }

}