import { LightningElement, api,track,wire } from "lwc";
import getWeatherDetails from '@salesforce/apex/WeatherController.getWeatherDetails';

export default class Weather extends LightningElement {
    @api recordId;
    error;
    weatherInfo;

    @wire(getWeatherDetails, { locationId: '$recordId' })
    weatherDetailsByType({ data, error }) {
        if (data) {
          console.log(JSON.stringify(data));
          this.weatherInfo = data;
          if (error)
            console.log(error);
            this.error = error;
        }
      }

}