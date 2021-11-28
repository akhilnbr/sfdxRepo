@istest
public class TestForCaseExcersise {
    @istest static void testupdateSubject(){
        
        list<case> updateCase = new list<case>();
        for(integer i=0;i<100;i++){
            updateCase.add(new case(Status='New',origin='Phone',Count__c=i,accountID='0012v00002jFf5pAAC',contactID='0032v00003NZKkqAAH'));
        }
        INSERT updateCase;
       
    }

}