public class triggerForTask {
        
        public static void updateTask(list<task> updatetaskList){
            map<id,task> taskByWhatID = new map<id,task>();
            map<date,string> subjectByDate = new map<date,string>();
            for(task obj:updatetaskList){
                taskByWhatID.put(obj.whatid,obj);
                subjectByDate.put(obj.ActivityDate,obj.subject);
            }
            list<Account> accountList = new list<Account>();
            accountList = [SELECT subject__c,Next_Activity__c 
                           FROM Account 
                           WHERE ID IN: taskByWhatID.keySet()];
            list<account> newAccount = new list<account>();
            for(Account objAccount: accountList){
                for(task obj:updatetaskList){
                    if(objAccount.Next_Activity__c>obj.ActivityDate||objAccount.Next_Activity__c==null){
                        objAccount.subject__c=obj.Subject;
                        objAccount.Next_Activity__c= obj.ActivityDate;
                        newAccount.add(objAccount);
                    }
                }
            }
            UPDATE newAccount;
        }
        
        public static void insertTask(list<task> getNewTask){
            map<id,task> taskByWhatID = new map<id,task>();
            set<id> setofWhatid = new set<id>();
            for(task obj:getNewTask){
                taskByWhatID.put(obj.whatid,obj);
                setofWhatid.add(obj.whatid);
            }
            list<Account> accountList = new list<Account>();
            accountList = [SELECT subject__c,Next_Activity__c 
                           FROM Account 
                           WHERE ID IN: taskByWhatID.keySet()];
            list<task> getTask = [SELECT Subject,ActivityDate,whatid 
                                  FROM task 
                                  WHERE whatid iN:setofWhatid];
            list<account> newAccount = new list<account>();
            for(Account objAccount: accountList){
                for(task obj:getTask){
                    if(objAccount.Next_Activity__c>obj.ActivityDate||objAccount.Next_Activity__c==null){
                        objAccount.subject__c=obj.Subject;
                        objAccount.Next_Activity__c= obj.ActivityDate;
                        newAccount.add(objAccount);
                    }
                }
            }
            UPDATE newAccount;
        }
    }