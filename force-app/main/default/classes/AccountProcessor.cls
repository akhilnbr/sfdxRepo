public class AccountProcessor {
    @future
    public static void countContacts(list<id> accounttIds){
        system.debug('accounttIds'+accounttIds);
        for(Account obj:[SELECT ID, 
                         (SELECT Id FROM Contacts) 
                         FROM Account 
                         WHERE Id =: accounttIds])
            
            
        {
            Account objACC = new Account(Id= obj.Id);
            objACC.Number_of_Contacts_c__c = obj.Contacts.size();
            
        }
        
        
        
        
        
        
    }
    
    
}