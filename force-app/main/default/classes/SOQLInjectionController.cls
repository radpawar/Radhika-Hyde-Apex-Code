Public with sharing class SOQLInjectionController{

public static List<Contact> getContactRecords( String Name) {

    List<Contact> contactRecords = new List<Contact>();
    contactRecords = database.query('SELECT Id FROM Contact'
                        +' WHERE Name Like \'%'+Name+'%\'  ');      
    
                         
    return contactRecords;

}

Public static List<Contact> getContactRecordInfo(String Name) {
    String NameR = '%' +Name+'%';
    List<Contact> Con = new List<Contact>();
    try{
    Con = [SELECT Id,Name FROM CONTACT Where Name like :NameR Order by Id DESC limit 100 offset 2];
    } catch(exception ex){System.debug('Error***'+ex);}
    return con;
}

//String.escapeSingleQuotes
Public static List<Contact> getContacts(String Name) {

String WhereCon  = ' LIKE \'%'+String.escapeSingleQuotes(Name)+'%\'';
List<Contact> conRecords = new List<Contact>();
        conRecords = database.query('Select Id from Contact where Name '+ WhereCon );

return conRecords;


}

}