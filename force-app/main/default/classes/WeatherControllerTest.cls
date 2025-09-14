/**
 * ─────────────────────────────────────────────────────────────────────────────────────────────────
 * @Class         Cover code Coverage for WeatherController, WeatherHelperController and WeatherBatchController classes 
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 */
@isTest
public with sharing class WeatherControllerTest {

@testSetup 
    static void setupData() {
        List<EPP_Test_RAD__Location__c> locationRecords = new List<EPP_Test_RAD__Location__c>();
        EPP_Test_RAD__Location__c location = new EPP_Test_RAD__Location__c();
        location.EPP_Test_RAD__City__c = 'Coventry';  
        location.EPP_Test_RAD__Country__c   =   'United Kingdom';   
        locationRecords.add(location);

        EPP_Test_RAD__Location__c location01 = new EPP_Test_RAD__Location__c();
        location01.EPP_Test_RAD__City__c = 'Isleworth';  
        location01.EPP_Test_RAD__Country__c   =   'United Kingdom';   
        locationRecords.add(location01);
        insert locationRecords;  

        List<EPP_Test_RAD__Weather__c> weatherRecords = new List<EPP_Test_RAD__Weather__c>();
        
        for( EPP_Test_RAD__Location__c param : [SELECT Id, EPP_Test_RAD__City__c, EPP_Test_RAD__CityId__c, EPP_Test_RAD__WeatherRecordCount__c
                                                           FROM EPP_Test_RAD__Location__c     ]){
            EPP_Test_RAD__Weather__c weatherRecord = new EPP_Test_RAD__Weather__c();
            weatherRecord.EPP_Test_RAD__Locations__c = param.Id;
           // weatherRecord.EPP_Test_RAD__Weather__c = 'Clouds';   
            weatherRecords.add(weatherRecord);                                                 
        }
        
        insert weatherRecords;
             
    }

    public static List<EPP_Test_RAD__Location__c> getLocationDetails(Id locationId) {
        List<EPP_Test_RAD__Location__c> locationRecords = new List<EPP_Test_RAD__Location__c>([SELECT Id, EPP_Test_RAD__JSON_Response_Body__c, EPP_Test_RAD__Response_code__c,
                                                            (SELECT Id, EPP_Test_RAD__Description__c,EPP_Test_RAD__Temp__c FROM EPP_Test_RAD__Weather__r)
                                                            FROM EPP_Test_RAD__Location__c 
                                                            WHERE Id=: locationId 
                                                            WITH SYSTEM_MODE 
                                                            ORDER BY CreatedDate DESC]);
        
        return locationRecords;

    }

    /**
     * @description To weather detaikls
    */
    @isTest
    private static void validateWeatherDetails() {
        EPP_Test_RAD__Weather__c weatherDetails = new EPP_Test_RAD__Weather__c();
        List<EPP_Test_RAD__Location__c> locationRecords = [SELECT Id, EPP_Test_RAD__City__c, EPP_Test_RAD__CityId__c, EPP_Test_RAD__WeatherRecordCount__c
                                                           FROM EPP_Test_RAD__Location__c     ];
        weatherDetails = WeatherController.getWeatherDetails(locationRecords[0].Id); 
        System.Assert.areEqual(locationRecords[0].Id, weatherDetails.EPP_Test_RAD__Locations__c);        
    }

    /**
     * @description To weather detaikls
    */
    @isTest
    private static void validateNegWeatherDetails() {
        EPP_Test_RAD__Weather__c weatherDetails = new EPP_Test_RAD__Weather__c();
        Test.startTest();

        try {
            List<EPP_Test_RAD__Location__c> locationRecords = [SELECT Id, EPP_Test_RAD__City__c, EPP_Test_RAD__CityId__c, EPP_Test_RAD__WeatherRecordCount__c
            FROM EPP_Test_RAD__Location__c WHERE  EPP_Test_RAD__City__c = 'Test'  ];
            weatherDetails = WeatherController.getWeatherDetails(locationRecords[0].Id); 
            System.Assert.areEqual(locationRecords[0].Id, weatherDetails.EPP_Test_RAD__Locations__c);
        } catch (Exception ex) {
            System.assertEquals('List index out of bounds: 0', ex.getMessage());
        }
        Test.stopTest();
    }

    /**
     * @description WeatherHelperController
    */
    @isTest
    private static void validateGetWeatherDetails() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherDetailsMockClass());  
        List<EPP_Test_RAD__Location__c> locationRecords = [SELECT Id, EPP_Test_RAD__City__c, EPP_Test_RAD__CityId__c, EPP_Test_RAD__WeatherRecordCount__c
                                                           FROM EPP_Test_RAD__Location__c     ];
        WeatherController.getWeatherFromRefershButton(locationRecords[0].Id);   
        List<EPP_Test_RAD__Location__c> locationRec = getLocationDetails(locationRecords[0].Id); 
        System.Assert.areEqual(locationRec[0].EPP_Test_RAD__Response_code__c, 200); 
        system.assertEquals(locationRec[0].EPP_Test_RAD__Weather__r[0].EPP_Test_RAD__Description__c, 'scattered clouds');                                              
        Test.stopTest();       
    }

    /**
     * @description WeatherHelperController
    */
    @isTest
    private static void validateNegGetWeatherDetails() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherNegativeResponseMock());  
        List<EPP_Test_RAD__Location__c> locationRecords = [SELECT Id, EPP_Test_RAD__City__c, EPP_Test_RAD__CityId__c, EPP_Test_RAD__WeatherRecordCount__c
                                                           FROM EPP_Test_RAD__Location__c     ];
        WeatherController.getWeatherFromRefershButton(locationRecords[0].Id);  
        List<EPP_Test_RAD__Location__c> locationRec = getLocationDetails(locationRecords[0].Id); 
        System.Assert.areEqual(locationRec[0].EPP_Test_RAD__Response_code__c, 404); 
        system.assertEquals(locationRec[0].EPP_Test_RAD__Weather__r.size(),0);                                              
                                                        
        Test.stopTest();       
    }

    
    /**
     * @description WeatherHelperController
    */
    @isTest
    private static void validateWeatherBatchController() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherDetailsMockClass());  
        WeatherBatchController ba= new WeatherBatchController();
        Id jobid= Database.executeBatch(ba,5);
        
        SchedulableContext sc = null;
        ScheduleWeatherBatchClass scWeather= new ScheduleWeatherBatchClass();
        scWeather.execute(sc);  
        Test.stopTest(); 
    }
    /**
     * @description To weather detaikls
    */
    @isTest
    private static void validateNegTGetWeatherDetails() {
        EPP_Test_RAD__Weather__c weatherDetails = new EPP_Test_RAD__Weather__c();
        Test.startTest();
        try {
            WeatherController.getWeatherFromRefershButton(null);
            
        } catch (Exception ex) {
            System.assertEquals('Couldn\'t update Location with ID null', ex.getMessage());
        }
        Test.stopTest();
    }
}
