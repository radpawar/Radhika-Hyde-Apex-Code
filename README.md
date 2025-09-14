
## How Do You Plan to Deploy Your Change
Step 1: Open your VS Code and open a new terminal.

Step 2: Enter git clone https://github.com/radpawar/Radhika-Hyde-Apex-Code.git to clone the repo.

Step 3: Check if the new directory is created in your local system and open this directory from VS Code using step 4 below.

Step 4: Go to VS Code, and select the 'Open Folder' option. Select the new directory folder so that it will open in VS Code.

Step 5: Open the command palette using Ctrl+Shift+P and create a default scratch org. 

Step 6: Once the default scratch org is created, now push your source component into it using the command palette Ctrl+Shift+P -> SFDX: Push Source to Default Scratch Org.

Step 7: Once the component is deployed into your org, it will give the notification/message that Push Source to Default scratch org successfully ran.

Also, you can check in your org via setup-> Deployment status and see the success/failure result. 


##  Post deployment steps: 
1. Get the password from repo Owner to update into named credentials.
2. Execute below cron expression from developer console -> execute anonymous window.  So that hourly, weather will be updated into the existing location records.
3. // Cron EXP for hourly schedule 
  String CRON_EXP = '0 0 * * * ?'; 
  ScheduleWeatherBatchClass sch = new ScheduleWeatherBatchClass(); 
  system.schedule('Hourly Weather Batch Schedule job', CRON_EXP, sch);
4. Assign Weather_Test_Permission_Set permission set to your User.

## Testing steps
Step 1: Go to the Location tab and make a new entry.
Step 2: You will be prompted to input City and County and click the Save button. Latitude and longitude values will be automatically filled in once you Saved. Additionally, a record of weather data (temperature, description, etc.) will be created using the OpenWeatherMap API. 
Weather information presented in an visual way on a location record page.
Step 3:  On the same page where the weather details are displayed from the location record, click the "Get Weather Details" button to retrieve the most recent weather information and display it visually.
