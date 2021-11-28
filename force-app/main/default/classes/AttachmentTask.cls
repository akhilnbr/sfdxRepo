public without sharing class AttachmentTask {
    
    public static void TriggerTask(list<ContentDocumentLink> getDocument) {	
        string docId;
        list<Id> parentTaskIdSet = new list<id>();
        set<Id> linkentityId = new set<id>();
        system.debug(getDocument);
        for(ContentDocumentLink versionObj :getDocument)
        {
            if(versionObj.ContentDocumentId!=null)
            {
                
                parentTaskIdSet.add(versionObj.ContentDocumentId);
                docId = versionObj.LinkedEntityId;
            }
            
        }
        list<case> updateCase = new list<case>();
        list<case> getCases = [select id, AccountId, CaseNumber, Origin, OwnerId, Count__c 
                               from Case
                               where id =:docId ];
      
        list<AggregateResult> getCount = [select count(id) from ContentDocumentLink where linkedentityid=:docId];
 		object total_used = getCount[0].get('expr0');
        for(case caseObj: getCases)
        {
            if(caseObj.Id!=null)
            {
               	caseObj.Count__c = (decimal)total_used;
                updateCase.add(caseObj);
            }
            
        }
        update updateCase;
        
    }
    
}