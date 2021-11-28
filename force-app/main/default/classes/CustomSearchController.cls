public with sharing class CustomSearchController {
    
    /* Create an Aura Enabled Method which tooks objectName, fieldtoSearch and the text to search */
    /* Develop the Dynamic SOSL and then use Query method of Search Class to return the result */
    @AuraEnabled
    public static String searchRecords(String objName, String fieldName, 
                                     String searchKey){
        String searchKeyword = searchKey + '*';
        String returningQuery = objName+' ( Id, '+fieldName+')';
        String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 2000';
        List<List<sObject>> sobjectList = Search.query(Query);
        return JSON.serialize(sobjectList);
    }
}