public without  sharing class Pagination {
  
    @AuraEnabled(cacheable=true)
    public static List<Account> retrieveAccount(){
        
        return [SELECT Id,Name from Account limit 23];
    }
}