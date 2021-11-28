public class CreateATaskOnOpportunityTrigger {
    public static void createNewTask(list<Opportunity> getOpportunity)
    {
        
        List<Opportunity_Record_Type__mdt> oppRecordTypeList = [SELECT id,RecordType__c,DeveloperName,
                                                                (SELECT Id, Due_Date__c, Status__c, Subject__c
                                                                 FROM Related_Tasks__r)
                                                                FROM Opportunity_Record_Type__mdt];
        Map<String, Opportunity_Record_Type__mdt> OppRecordTypeMdtByRtName = new Map<String, Opportunity_Record_Type__mdt>();
        Map<Id, String> idByRecordtypeName = new Map<Id, String>();
        for(Recordtype rt : [SELECT ID, developerName 
                             FROM Recordtype 
                             WHERE sObjectType ='Opportunity' and isActive = true])
        {
            idByRecordtypeName.put(rt.Id, rt.developerName);
        }
        for(Opportunity_Record_Type__mdt obj :  oppRecordTypeList){
            system.debug('obj>>>>>>'+obj);
            OppRecordTypeMdtByRtName.put(obj.DeveloperName, obj);
        }
        List<Task> taskList = new List<task>();
        system.debug('OppRecordTypeMdtByRtName___'+OppRecordTypeMdtByRtName);
        for(Opportunity opp :(List<Opportunity>)trigger.new){
            String recordTypeName = idByRecordtypeName.get(opp.RecordTypeId);
            Opportunity_Record_Type__mdt obj = OppRecordTypeMdtByRtName.get(recordTypeName);
            if(obj.Related_Tasks__r.size() > 0){
                taskList.addAll(taskCreate(obj, opp));
            }
        }
        INSERT taskList;
    }
    private static List<Task> taskCreate(Opportunity_Record_Type__mdt oppRtmdt, Opportunity record){
        List<Task> taskList = new List<Task>();
        for(Related_Task__mdt taskmdtObj : oppRtmdt.Related_Tasks__r){
            Date oppCreatedDate = record.CreatedDate.date();
            Integer taskdueDate = Integer.valueof(taskmdtObj.Due_Date__c);
            Task taskObj = new Task();
            taskObj.Subject = taskmdtObj.Subject__c;
            taskObj.Status = taskmdtObj.Status__c;
            taskObj.ActivityDate = oppCreatedDate.addDays(taskdueDate);
            taskObj.WhatId = record.Id;
            taskList.add(taskObj);
        }
        return taskList;        
    }
}