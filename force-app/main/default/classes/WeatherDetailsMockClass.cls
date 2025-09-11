/**
 * ─────────────────────────────────────────────────────────────────────────────────────────────────
 * @Class         Cover code Coverage for WeatherController, WeatherHelperController and WeatherBatchController classes 
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 */
@isTest
global class WeatherDetailsMockClass implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        String json=		'{'+
		'    "coord": {'+
		'        "lon": -1.5122,'+
		'        "lat": 52.4066'+
		'    },'+
		'    "weather": ['+
		'        {'+
		'            "id": 802,'+
		'            "main": "Clouds",'+
		'            "description": "scattered clouds",'+
		'            "icon": "03d"'+
		'        }'+
		'    ],'+
		'    "base": "stations",'+
		'    "main": {'+
		'        "temp": 16.86,'+
		'        "feels_like": 16.3,'+
		'        "temp_min": 15.87,'+
		'        "temp_max": 17.04,'+
		'        "pressure": 1000,'+
		'        "humidity": 65,'+
		'        "sea_level": 1000,'+
		'        "grnd_level": 990'+
		'    },'+
		'    "visibility": 10000,'+
		'    "wind": {'+
		'        "speed": 4.63,'+
		'        "deg": 220'+
		'    },'+
		'    "clouds": {'+
		'        "all": 40'+
		'    },'+
		'    "dt": 1757592988,'+
		'    "sys": {'+
		'        "type": 2,'+
		'        "id": 2039874,'+
		'        "country": "GB",'+
		'        "sunrise": 1757568835,'+
		'        "sunset": 1757615504'+
		'    },'+
		'    "timezone": 3600,'+
		'    "id": 2652221,'+
		'    "name": "Coventry",'+
		'    "cod": 200'+
		'}';
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(json);
        response.setStatusCode(200);
        return response; 
    }
}
