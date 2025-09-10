public with sharing class DynamicPicklistController {

    @AuraEnabled(cacheable=true)
    public static List <customValueWrapper> pickListValueDynamically(string selectPicklistApi) {
        System.debug('selectPicklistApi***'+selectPicklistApi);
    Schema.DescribeSObjectResult objDescribe = Task.getSObjectType().getDescribe();
    map <String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();
    list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
    list < customValueWrapper > customObjWrapper = new list < customValueWrapper > ();
    for (Schema.PicklistEntry myCustPick: custPickValues) {
        customValueWrapper selectOptionValueWrapper = new customValueWrapper();
        selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
        selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
        customObjWrapper.add(selectOptionValueWrapper);    
    }    
    System.debug('customObjWrapper***'+customObjWrapper);
    return customObjWrapper;    
    }
    
    public with sharing class customValueWrapper {

        @AuraEnabled public string custFldlabel {get;set;}        
        @AuraEnabled public string custFldvalue {get;set;}
        
        }    
}