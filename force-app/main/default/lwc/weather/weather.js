import { LightningElement, api,wire } from "lwc";
import getWeatherDetails from '@salesforce/apex/WeatherController.getWeatherDetails';
import getWeatherFromRefershButton from '@salesforce/apex/WeatherController.getWeatherFromRefershButton';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

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

      async handleRefershWeather(event) {
        console.log('event details****'+event.detail);
        console.log('event  this.recordId ****'+ this.recordId );
         try {
          await getWeatherFromRefershButton({ locationId: this.recordId });
          // Report success with a toast
          this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Weather details updated',
                    variant: 'success'
                })
            );

            // Display fresh data in the datatable
            await refreshApex(this.weatherInfo);            
        } catch (error) {           
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while updating or refreshing records',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
      }

}