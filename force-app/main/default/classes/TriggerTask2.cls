public class TriggerTask2 {
    public static void TriggerTask(list<ContentDocument> getDocument) {	
        System.debug('entering');
        Set<Id> parentTaskIdSet = new Set<id>();           
        for(ContentDocument docObj: getDocument)
        {
            system.debug('obj'+docObj.Id);
            system.debug('parentid'+docObj.ParentId);
        }
        list<Case> getCases = [select id from case where ParentId in: parentTaskIdSet];
        list<case> updatedCaseList = new LIST<case>();
        for(Case ObjCase: getCases)       
        {
            //ObjCase.Count__c  = ObjCase.Attachments.size();
            //updatedCaseList.add(ObjCase);
        }
        update updatedCaseList;
    }
    
    
}