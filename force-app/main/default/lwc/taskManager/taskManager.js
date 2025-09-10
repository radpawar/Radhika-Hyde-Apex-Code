import { LightningElement, api,track,wire } from "lwc";
import getRecords from '@salesforce/apex/TaskManagerController.getTaskDetails';
import updateTasks from '@salesforce/apex/TaskManagerController.updateTaskDetails';
import LightningDatatable from 'lightning/datatable';
//import statusPicklist from './statusPicklist.html';
//import statusPicklistEdit from './statusPicklistEdit.html';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Subject', fieldName: 'Subject', type: 'text' },    
    { label: 'Due Date', fieldName: 'ActivityDate', type: 'date' },
    { label: 'Status', fieldName: 'Status', type: 'picklist', editable: true,
        typeAttributes: {
            options: [
                { label: 'In Progress', value: 'In Progress' },
                { label: 'Completed', value: 'Completed' },
                { label: 'Wating on someone else', value: 'Wating on someone else' },
            ] // list of all picklist options
            , value: { fieldName: 'Status' } // default value for picklist  editable: true ,
            , context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
        }
    },  
   
];

export default class Weather extends LightningElement {
    columns = columns;
    records = [];
    draftValues = [];
    @track isPopupOpen = false;   

   /* @wire(getRecords)
    wiredTaskRecords({error, data}) {
        if(data) {
            console.log('data '+JSON.stringify(data));
            this.records = data;           
        }
        if(error) {
            this.error=error;
        }
    }*/

    connectedCallback() {
        console.log('connectedCallback***');
        this.loadData();
    }

    async loadData() {
        console.log('loadData***');
        try {
            this.records = await getRecords();
            console.log('this.records***', this.records);
        } catch (error) {
            console.log('Error while getting initial data', error);
        } finally {
        // this.isLoading = false;
        }  
    }


    createTask() {
        console.log('create task***');
        this.isPopupOpen = true;
        
    }

    handleClose() {
        this.isPopupOpen = false;
        console.log('isPopupOpen***');
        this.loadData();
        
    }
    
    saveHandleAction(event) {        
       console.log(
            'event.detail.draftValues***' + JSON.stringify(event.detail.draftValues)
          )
          var draftValuesStr = JSON.stringify(event.detail.draftValues);
          updateTasks({taskRecords: draftValuesStr}).then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Task updated',
                    variant: 'success'   
                })
            );  // End of dispatchEvent
            this.draftValues = [];
            refreshApex(this.getRecords);
            this.loadData();
        }).catch(error => {
            // Handle error
        });
    }

    updateModalBox(event) {
        console.log('event.detail.message***'+event.detail.message);
        this.isPopupOpen  = event.detail.message;
        console.log('isPopupOpen***'+this.isPopupOpen);
        this.loadData();
    }
}