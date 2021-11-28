@isTest
private class AccountProcessorTest {
    @isTest
    private static void testAccount(){
        Test.startTest();
        list<id> accountID = new list<id>();
        Account obj = new Account(Name='Test001',Phone='9645242454');
        Contact obj1 = new Contact(lastname = 'asjasdkasd',AccountId = obj.id);
        
        INSERT obj;
        INSERT obj1;
        accountID.add(obj.Id);
        AccountProcessor.countContacts(accountID);
        Test.stopTest();
        
    }
    
    
}