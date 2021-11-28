public with sharing class CustomDataTable {
    @AuraEnabled(cacheable=true)
    public static List<Sobject> fetchCustomerdetails()
    {
        System.debug('Begin: fetchCustomerdetails');
        
        return [SELECT Name,Active__c,AnnualRevenue,AccountSource
                FROM Account];             
       
    }
}