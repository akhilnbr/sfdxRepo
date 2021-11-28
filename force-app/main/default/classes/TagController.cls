public without sharing class TagController {
    public TagController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getObjectTags(String lookupFieldApiName, Id recordId) {
        List<Contact> tagItems = new List<Contact>();
        String query = 'SELECT Id, Name FROM Contact WHERE ' + lookupFieldApiName + ' = \'' + recordId + '\' ';
        System.debug(query);
        tagItems = Database.query(query);
        return tagItems;
    }

    /* Create an Aura Enabled Method which tooks objectName, fieldtoSearch and the text to search */
    /* Develop the Dynamic SOSL and then use Query method of Search Class to return the result */
    @AuraEnabled
    public static String searchRecords(String objName, String fieldName, 
                                     String searchKey){
        String searchKeyword = searchKey + '*';
       String returningQuery = objName+' ( Id, CreatedById, '+fieldName+')';
String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery + ' LIMIT 2000';
        List<List<sObject>> sobjectList = Search.query(Query);
        return JSON.serialize(sobjectList);
    }

    @AuraEnabled
    public static String getRecents(List<String> appliedTagNames){
        List<List<sObject>> sobjectList = new List<List<sObject>>();
        List<sObject> recentTags = [SELECT Id, Name FROM Contact WHERE Name NOT IN: appliedTagNames ORDER BY LastReferencedDate  DESC LIMIT 3];
        sobjectList.add(recentTags);
        System.debug('sobjectList==>'+sobjectList);
        return JSON.serialize(sobjectList);
    }

  


}