/******************************************************************************************
 *  Date          : 11 Sep
 *  Author        : Radhika Pawar
 *  Description   : This is helper class used for Batch class and LWC component 
 * Modifications  : 
 * ***************************************************************************************/
public with sharing class WeatherHelperController {

   /**
     * @description This method called from lightning component for wired method and the Batch class(Reused for both places)
     * @param locationInfo,weatherResponseMap
    */
    public static void getWeatherDetails(EPP_Test_RAD__Location__c locationInfo, Map<EPP_Test_RAD__Location__c, WeatherHelperController.WeatherResponseWrapperClass> weatherResponseMap) {
        String cityName = locationInfo.EPP_Test_RAD__City__c;
        HttpResponse response = getWeatherResponse(cityName);
        System.debug('response***'+response.getBody());
        WeatherHelperController.WeatherResponseWrapperClass results =(WeatherHelperController.WeatherResponseWrapperClass) System.JSON.deserialize(response.getBody(), WeatherHelperController.WeatherResponseWrapperClass.class);
        weatherResponseMap.put(locationInfo, results);    
    }
    /**
     * @description This method used to the weather response from the API
     * @param city
     * @return HttpResponse 
    */
    public static HttpResponse getWeatherResponse(String city){
        String cityName = city;
        String apiKey = '7074dd594c9481c701390717e693f49a'; // Replace with your actual API key
        String endpoint = 'https://api.openweathermap.org/data/2.5/weather?q=' + cityName + '&appid=' + apiKey +'&units=metric';

        HttpRequest request = new HttpRequest();
        //request.setEndpoint('callout:bulkfyWeatherAPI'+ '?q='+cityName );
        // request.setHeader('appid', '{!$Credential.WeatherAPICredentials_EX.password}');
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('response***'+response.getBody());
        return response;
    } 

    /**
     * @description This method update the table based on responses
     * @param weatherResponseMap
    */
    public static void updateWeatherInfo(Map<EPP_Test_RAD__Location__c, WeatherHelperController.WeatherResponseWrapperClass> weatherResponseMap) {
       System.debug(' updateWeatherInfo methoid weatherResponseMap***'+weatherResponseMap);
        List<EPP_Test_RAD__Location__c> locationUpdates = new List<EPP_Test_RAD__Location__c>();
        List<EPP_Test_RAD__Weather__c> weatherUpdates = new List<EPP_Test_RAD__Weather__c>();
        Set<Id> deleteWeatherRecords = new Set<Id>();

        if (weatherResponseMap.isEmpty() ) {
            return ;
        }

        for(EPP_Test_RAD__Location__c locationInfo : weatherResponseMap.keySet()) {               
            WeatherHelperController.WeatherResponseWrapperClass results = weatherResponseMap.get(locationInfo);
            System.debug('results***'+results);
            
            if(results.cod != 200) {
                System.debug('results.cod***'+results.cod);
                deleteWeatherRecords.add(locationInfo.Id);
                locationUpdates.add(getStatusCodeForFailedResponse(locationInfo, results));
                continue;
            }

            locationInfo.EPP_Test_RAD__Location__latitude__s = results.coord.lat;
            locationInfo.EPP_Test_RAD__Location__longitude__s = results.coord.lon;
            locationInfo.EPP_Test_RAD__JSON_Response_Body__c = String.valueof(results);
            locationInfo.EPP_Test_RAD__Response_code__c = results.cod;
            locationInfo.EPP_Test_RAD__CityId__c = String.valueOf(results.id);
            locationUpdates.add(locationInfo);

            EPP_Test_RAD__Weather__c weatherInfo = new EPP_Test_RAD__Weather__c();
            if(locationInfo.EPP_Test_RAD__Weather__r.size()>0){
                weatherInfo.Id = locationInfo.EPP_Test_RAD__Weather__r[0].Id;   
                System.debug('weatherInfo.Id***'+weatherInfo.Id);
            }
            weatherInfo.EPP_Test_RAD__Description__c = results.weather[0].description;
            weatherInfo.EPP_Test_RAD__Locations__c = locationInfo.Id;
            weatherInfo.EPP_Test_RAD__humidity__c = results.main.humidity;  
            weatherInfo.EPP_Test_RAD__temp__c = results.main.temp;
            weatherInfo.EPP_Test_RAD__temp_max__c = results.main.temp_max;
            weatherInfo.EPP_Test_RAD__temp_min__c = results.main.temp_min;
            weatherInfo.EPP_Test_RAD__wind_speed__c = results.wind.speed;
            weatherUpdates.add(weatherInfo);
        }

        System.debug('locationUpdates***'+locationUpdates);
        if(!locationUpdates.isEmpty()){
            List<Database.SaveResult> updateResults = Database.update(locationUpdates,false);
            System.debug('locationUpdates***'+updateResults);
        }
        System.debug('weatherUpdates***'+weatherUpdates);
        if(!weatherUpdates.isEmpty()){
            //upsert weatherUpdates Id;
            Schema.SObjectField f = EPP_Test_RAD__Weather__c.Fields.Id;
            List<Database.UpsertResult> upsertResults = Database.upsert(weatherUpdates , f, false);
            System.debug('upsertResults***'+upsertResults);
        }

        if(!deleteWeatherRecords.isEmpty()){
            getUnRequiredWeatherRecords(deleteWeatherRecords);
        }
        
    }

    /**
     * @description This method update the table based on responses
     * @param locationInfo
     * @return EPP_Test_RAD__Location__c
    */
    public Static EPP_Test_RAD__Location__c getStatusCodeForFailedResponse(EPP_Test_RAD__Location__c locationInfo,WeatherHelperController.WeatherResponseWrapperClass results) {
        locationInfo.EPP_Test_RAD__JSON_Response_Body__c = String.valueof(results);
        locationInfo.EPP_Test_RAD__Response_code__c = results.cod;
        
        return locationInfo;
    }

    /**
     * @description This method update the table based on responses
     * @param deleteWeatherRecord
    */
    public static void getUnRequiredWeatherRecords(Set<Id> deleteWeatherRecord){
        List<EPP_Test_RAD__Weather__c> weatherRecord = [SELECT Id FROM EPP_Test_RAD__Weather__c
                                                         WHERE EPP_Test_RAD__Locations__c IN: deleteWeatherRecord ];

        List<Database.DeleteResult> results = Database.delete(weatherRecord, false);
    }

    /**
     * @description This method used for bulkification
     * @param weatherResponseMap
    */
   /* public static void getWeatherWithBulkDetails(){
        Http h = new Http();
        Httprequest httpreq = new httprequest();
        httpReq.setEndpoint('callout:Key_APi_Rotation/generateApiKey');
        httpReq.setMethod('POST');
        httpReq.setHeader('X-API-KEY', '{!$Credential.key_Api_rotation_Ex.password}');
        httpReq.setHeader('Content-Type', 'application/json');
        System.debug('before request***'+httpReq);
        HttpResponse response = h.send(httpReq);    
        System.debug('response***'+response);
        System.debug('BODY***'+response.getBody());
        System.debug('get status Code***'+response.getStatusCode());
        map<string,string> responseMap = (map<string,string>)JSON.deserialize(response.getBody(),map<string,string>.class); 
        system.debug('responseMap Value ='+responseMap);

    }*/

    /**
     * @description This is wrapper class to read wetherAPI response
    */
    public class WeatherResponseWrapperClass{ 
        public cls_coord coord;
        public cls_weather[] weather;
        public String base;	//stations
        public cls_main main;
        public Integer visibility;	//10000
        public cls_wind wind;
        public cls_clouds clouds;
        public Integer dt;	//1757592988
        public cls_sys sys;
        public Integer timezone;	//3600
        public Integer id;	//2652221
        public String name;	//Coventry
        public Integer cod;	//200
    }
    
    class cls_coord {
            public Double lon;	//-1.5122
            public Double lat;	//52.4066
    }
    class cls_weather {
        public Integer id;	//802
        public String main;	//Clouds
        public String description;	//scattered clouds
        public String icon;	//03d
    }
    class cls_main {
        public Double temp;	//16.86
        public Double feels_like;	//16.3
        public Double temp_min;	//15.87
        public Double temp_max;	//17.04
        public Integer pressure;	//1000
        public Integer humidity;	//65
        public Integer sea_level;	//1000
        public Integer grnd_level;	//990
    }
    class cls_wind {
        public Double speed;	//4.63
        public Integer deg;	//220
    }
    class cls_clouds {
        public Integer all;	//40
    }
    class cls_sys {
        public Integer type;	//2
        public Integer id;	//2039874
        public String country;	//GB
        public Integer sunrise;	//1757568835
        public Integer sunset;	//1757615504
    }

    public class WeatherDetailsException extends Exception {}
}