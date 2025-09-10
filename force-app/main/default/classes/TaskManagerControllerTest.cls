@isTest
public with sharing class TaskManagerControllerTest {
    @isTest
    static void validateTaskRetrivalData() {
        List<account> accList = new List<account>();
        account acc = MockTestDataFactoryController.createAccount('Radhika','4254437516',
        'Customer');                
        accList.add(acc);
        insert accList;

        List<Task> createTasks = new List<Task>();
        Task taskCreation = MockTestDataFactoryController.createTasks('Radhika task created',date.today()+30,'Normal',
        accList[0].Id);
        createTasks.add(taskCreation);   
        insert createTasks;
        List<Task> createTaskRecords = new List<Task>();
        Test.startTest();
        
        createTaskRecords = TaskManagerController.getTaskDetails();
        Test.stopTest();

        System.assertEquals(1, createTaskRecords.size(), 'There should be 1 task');
    }

    @isTest
    static void validateTaskCreationData() {
        List<account> accList = new List<account>();
        account acc = MockTestDataFactoryController.createAccount('Radhika','4254437516',
        'Customer');                
        accList.add(acc);
        insert accList;      
        Map<String,String> retrievePickListFields = new Map<String, String>();

        Test.startTest();        
        TaskManagerController.createTaskRecordInfo('Radhika task created',date.today()+30,'Normal');
        TaskManagerController.retrievePickListFields('Subject');

        Test.stopTest();
        List<Task> createTasks = new List<Task>();
        createTasks = [SELECT Id FROM TASK ];
        System.assertEquals(1, createTasks.size(), 'There should be task');

        TaskManagerController.updateTaskDetails(createTasks);
    }
}