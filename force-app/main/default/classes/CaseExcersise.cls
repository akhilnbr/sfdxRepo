public class CaseExcersise {
    public static void updateSubject(list<case> getNewCase){
        map<string,case> statusByCase = new map<string,case>();
        for(case objCase:getNewCase){
            statusByCase.put(objCase.Status,objCase);
        }
        list<case> cases = [SELECT id,subject,status 
                            FROM case 
                            WHERE status IN:statusByCase.keyset() 
                            AND subject=''];
        list<case> updateCase = new list<case>();
        if(!cases.isEmpty()){
            for(case obj:cases){
                obj.Subject=obj.Status;
                updateCase.add(obj);
            }
        }
        update updateCase;
    }
    public static void checkForContactorAccountInCase(list<case> getNewCase){
        string getId;
        string getAccId;
        map<string,contact> contactIdMap = new map<string,contact>();
        set<id> accountIdSet = new set<id>();
        set<id> contactIDSet = new set<id>();
        list<case> updateCase = new list<case>();
        for(case objCase:getNewCase){
            if(objCase.AccountId!=null){
                accountIdSet.add(objCase.AccountId);
            }
            else if(objCase.ContactId!=null){
                contactIDSet.add(objCase.ContactId);
            }
        }
        List<Account> acctList = new List<Account>();
        acctList = [SELECT Id, Name,(SELECT Id, Name From Contacts) 
                    From Account 
                    WHERE ID In:accountIdSet];
        List<Contact> contactList = [SELECT ID,Name, Account.ID 
                                     FROM Contact 
                                     WHERE ID IN:contactIDSet];
        
        for(Account objA:acctList){
            for(contact objC:objA.contacts){
                getId= objC.Id;
            }
        }
        for(Contact objContactList:contactList){
            getAccId = objContactList.AccountId;
        }
        
        for(case objCase:getNewCase){
            updateCase.add(new case(
                ID=objCase.id,ContactId =getId,AccountId=getAccId));
        }
        UPDATE updateCase; 
        
    }
    
}