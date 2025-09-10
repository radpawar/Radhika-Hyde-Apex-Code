import { LightningElement, api,track,wire } from "lwc";
import createRecords from '@salesforce/apex/TaskManagerController.createTaskRecordInfo';
import retrievePicklist from '@salesforce/apex/TaskManagerController.retrievePickListFields';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
/**
 * Creates Account records.
 */
export default class AccountCreator extends LightningElement {
  
  @track subject;
  @track priority;
  @track dueDate;
  @track options = [];
  @track priorityOptions = [];
  @track selectedOption;
  @track sub = 'Subject';
  @track priorityval = 'Priority';
  picklistValue;
  picklistValPriority;
  closemodal = false;

  loaded = false;
  priorityloaded = false;
  @wire(retrievePicklist , { fieldApiName: '$sub' }) 
  wiredLabels({error, data}){
      if(data){
          console.log('data '+JSON.stringify(data))
          for(var key in data){
          console.log('this.obj '+JSON.stringify({label:key, value:data[key]}))
          this.options.push({label:key, value:data[key]});
      }
      this.loaded = true;
  }
  if(error){
      this.error=error;
  }
  }

  @wire(retrievePicklist , { fieldApiName: '$priorityval' }) 
  wiredPriorityLabels({error, data}){
      if(data){
          console.log('data '+JSON.stringify(data))
          for(var key in data){
          console.log('this.obj '+JSON.stringify({label:key, value:data[key]}))
          this.priorityOptions.push({label:key, value:data[key]});
      }
      this.priorityloaded = true;
  }
  if(error){
      this.error=error;
  }
  }


  handelSubjectchange(event){
    this.subject = event.target.value;
    console.log('subject***'+this.subject);
  }

  handelPrioritychange(event){
    this.priority = event.target.value;
    console.log('priority***'+this.priority);
  }

  handelDatechange(event){ 
    this.dueDate = event.target.value;
    console.log('this.dueDate***'+this.dueDate);
  }

  createTaskRecordInfo() {
    createRecords({ subject : this.subject, dueDate: this.dueDate, priority: this.priority })
    .then(result => {
        this.message = result;
        this.error = undefined;
        if(this.message !== undefined) {
          
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Task created',
                    variant: 'success',
                }),
            );

            this.dispatchEvent(new CustomEvent('closemodal', {
              detail: {
                  message: this.closemodal
              }
          }));
        }
        
        console.log(JSON.stringify(result));
        console.log("result", this.message);
    })
    .catch(error => {
        this.message = undefined;
        this.error = error;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error creating record',
                message: error.body.message,
                variant: 'error',
            }),
        );
        console.log("error", JSON.stringify(this.error));
    });

  }

  handleClose() {
      this.dispatchEvent(new CustomEvent('closemodal', {
        detail: {
            message: this.closemodal
        }
      }));
  }
}