public with sharing class DynamicModalPopUp {
    public DynamicModalPopUp() {
        
    }
    @AuraEnabled
    public static TypeAheadRes[] getTaskRelatedContact(string rID){
        TypeAheadRes[] resList = new TypeAheadRes[]{};
            set<id> setOfRelationId = new set<id>();
        list<TaskRelation> tempRecord = [SELECT id,Relation.name 
                                         FROM TaskRelation
                                         WHERE taskid=:rID 
                                         AND Iswhat=false];
        for(TaskRelation obj:tempRecord){
            setOfRelationId.add(obj.RelationId);
        }
        list<contact> getContactList = [SELECT id,name 
                                        FROM contact WHERE id in:setOfRelationId];
        for(contact listObj:getContactList){
            String realName = (String)listObj.get('Name');
            resList.add(new TypeAheadRes((Id)listObj.get('Id'), realName));
        }
        system.debug('resList'+resList);
        return resList;
    }
    @AuraEnabled
    public static TypeAheadRes[] typeAheadFuncLtng(String rName, String sObjName,String filterField,String filter)
    {
        return TypeaheadFunction.srch(rName,sObjName,filterField,filter);
        
    }
    
    @AuraEnabled
    public static list<AccData__mdt> getMetadata(string selectedButton){
        system.debug('><><><><');
        if(selectedButton!=null){
            list<AccData__mdt> listmetadata  = [SELECT Activity_Date__c,Comment__c,Next_Action__c,Subject__c 
                                                FROM AccData__mdt 
                                                WHERE label=:selectedButton];
            system.debug('listmetadata>>>>>>>>>>>>>>'+listmetadata);
            return listmetadata;
            
        }
        return null;
        
    }
    @AuraEnabled
    public static void saveNewTask(list<task> getSobecjtDetails,string rName,list<string> relatedContact){
        list<task> saveNewTask = new LIST<task>(); 
        
        for(Task objTask:getSobecjtDetails)
        {
            Task obj = new task();
            obj.Subject__c = objTask.Subject__c;
            obj.Activity_Date__c =  objTask.Activity_Date__c;
            obj.Comment__c = objTask.Comment__c;
            obj.Next_Action__c = objTask.Next_Action__c;
            obj.whatid = rName;
            obj.subject =objTask.Subject__c;
            saveNewTask.add(obj);
            
        }
        INSERT saveNewTask;
        
        
        list<TaskRelation> createNewTaskRelation = new list<TaskRelation>();
        for(string objR:relatedContact){
            for(task obj:saveNewTask){
                TaskRelation newTaskRelation = new TaskRelation();
                newTaskRelation.RelationId = objR;
                newTaskRelation.TaskId = obj.Id;
                newTaskRelation.IsWhat = false;
                createNewTaskRelation.add(newTaskRelation);
            }
        }
        INSERT createNewTaskRelation;
    }
    @AuraEnabled
    public static void updateTaskWithContact(list<string> getUpdatedRelatedContactList,string rId){
        SYSTEM.debug('getUpdatedRelatedContactList'+getUpdatedRelatedContactList);
        list<TaskRelation> updateRelation = new list<TaskRelation>();
        for(String obj:getUpdatedRelatedContactList){
            TaskRelation objTaskRelation = new TaskRelation(taskid=rId,iswhat=false);
            objTaskRelation.RelationId = obj;
            updateRelation.add(objTaskRelation);            
        }
        INSERT updateRelation;
    }
    @AuraEnabled
    public static void deleteTaskWithContact(list<string> getDeletedContactList,string rId){
        
        system.debug('rid'+rId);
        system.debug('getDeletedContactList'+getDeletedContactList);
        list<TaskRelation> deleteAndUpdate  = [select id,relationid,taskid from taskrelation where taskid =:rId
                                               AND relationid IN:getDeletedContactList];
        system.debug('deleteAndUpdate'+deleteAndUpdate);
        delete deleteAndUpdate;
    }
    @AuraEnabled
    public static list<Task_Draft__c> autoSaveDetails(list<Task_Draft__c> getDetails,string rId,string buttonClicked){
        system.debug('>>>>>>>>>>>>');
        system.debug('getDetails'+getDetails);
        system.debug('buttonClicked'+buttonClicked);
        list<Task_Draft__c> getExistingDetails = [select id,Subject__c,accId__c,Comment__c,Activity_Date__c,Next_Action__c 
                                                  FROM  Task_Draft__c];
        list<Task_Draft__c> listToUpdate = new list<Task_Draft__c>();
        list<Task_Draft__c> insertedDraft = new list<Task_Draft__c>();
        list<Task_Draft__c> toDeleteExisting = new list<Task_Draft__c>();
        if(buttonClicked=='save'|| buttonClicked=='cancel'){
            toDeleteExisting = [select id,Subject__c,accId__c,Comment__c,Activity_Date__c,Next_Action__c 
                                FROM  Task_Draft__c];
            DELETE toDeleteExisting;
            toDeleteExisting.clear();
            system.debug('toDeleteExisting'+toDeleteExisting);
            
        }
        if(buttonClicked!='save'&& buttonClicked!='cancel' && buttonClicked!=null){
            system.debug('UPDATE BLOCK');
            if(!getExistingDetails.isEmpty()){
                for(Task_Draft__c objToUpdate:getDetails){
                    for(Task_Draft__c objexistingObj:getExistingDetails){
                        objexistingObj.accId__c =  objToUpdate.accId__c;
                        objexistingObj.Subject__c =  objToUpdate.Subject__c;
                        objexistingObj.Activity_Date__c =  objToUpdate.Activity_Date__c;
                        objexistingObj.Comment__c =  objToUpdate.Comment__c;
                        objexistingObj.Next_Action__c =  objToUpdate.Next_Action__c;
                        objexistingObj.accId__c =rId;
                        listToUpdate.add(objexistingObj);
                    }
                }
                UPDATE listToUpdate;
            }
        }
        if(buttonClicked!='save'&& buttonClicked!='cancel'){
            if(!getDetails.isEmpty()&&getExistingDetails.isEmpty()){
                system.debug('INSERT BLOCK');
                for(Task_Draft__c obj :getDetails){
                    Task_Draft__c objTaskDraft = new Task_Draft__c();
                    objTaskDraft.Subject__c = obj.Subject__c;
                    objTaskDraft.accId__c =rId;
                    objTaskDraft.Comment__c = obj.Comment__c;
                    objTaskDraft.Activity_Date__c = obj.Activity_Date__c;
                    objTaskDraft.Next_Action__c = obj.Next_Action__c;
                    objTaskDraft.isSaved__c = false;
                    insertedDraft.add(objTaskDraft);
                }
                INSERT insertedDraft;
            }
        }
        if(insertedDraft.size()>0){
            return insertedDraft;
        }
        system.debug('>>>>'+listToUpdate);
        return listToUpdate; 
    }
    @AuraEnabled
    public static list<Task_Draft__c> getAutoSaveDetails(string rID){
        system.debug('rid'+rID);
        return [SELECT id,Subject__c,isSaved__c,accId__c,Comment__c,Activity_Date__c,Next_Action__c 
                FROM  Task_Draft__c
                WHERE accId__c =:rId];
    }
  
    public class ButtonColorMetadaWrapper{
         @AuraEnabled
        public string developerName{get;set;}
         @AuraEnabled
        public string labelOfBt {get;set;}
        ButtonColorMetadaWrapper(string labelOfBt,string developerName){
            this.developerName = developerName;
           	this.labelOfBt = labelOfBt;
        }
    } 
    
    @AuraEnabled
    public static list<ButtonColorMetadaWrapper> getButtonColor(){
        list<ButtonColorMetadaWrapper> getValues = new list<ButtonColorMetadaWrapper>();
        map<string,string> developerNameByLabel = new map<string,string>();
        list<ButtonColor__mdt> getLabelAndDname= [select label,developername from ButtonColor__mdt];
        
        if(!getLabelAndDname.isEmpty()){
            for(ButtonColor__mdt objButtonColorMdt:getLabelAndDname){
                developerNameByLabel.put(objButtonColorMdt.label,objButtonColorMdt.developername);
            }    
        }
        for(ButtonColor__mdt objButtonColorMdt:getLabelAndDname){
           if(developerNameByLabel.containsKey(objButtonColorMdt.label)){
            getValues.add(new ButtonColorMetadaWrapper(objButtonColorMdt.label,objButtonColorMdt.developername));
           }
        }
        system.debug('getValues'+getValues);
        return getValues;
        }
        
        
    }