public with sharing class DatatableExtract {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(){
        return [SELECT NAME,firstname,lastname FROM Contact LIMIT 10];
    }
}