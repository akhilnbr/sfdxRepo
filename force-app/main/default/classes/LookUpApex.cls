public with sharing class LookUpApex {
    @AuraEnabled
    public static TypeAheadRes[] typeAheadFuncLtng(String rName, String sObjName,String filterField,String filter)
    {
         system.debug('>><>>>lgthfun');
        return TypeaheadFunction.srch(rName,sObjName,filterField,filter);
        
    }
    @AuraEnabled
    public static void updateTasks(string getSelectedContact,id rId){
        id taskId = rId;
        Type idArrType = Type.forName('List<string>');
        List<string> wrapperList = (List<string>) JSON.deserialize(getSelectedContact, idArrType);  
        list<TaskRelation> updateTaskRelation = new list<TaskRelation>();
        updateTaskRelation = [select taskid,RelationId, Relation.Name 
                              FROM TaskRelation 
                              WHERE taskid=:rId AND ISWHAT=:false];
        list<TaskRelation> relationList = new list<TaskRelation>();
        for(integer i=0;i<wrapperList.size();i++){
            TaskRelation relationObj = new TaskRelation(taskID=taskId,iswhat=false );
            relationObj.RelationId= wrapperList[i];
            relationList.add(relationObj);
        } 
        INSERT relationList;
        
        
        
        
    }
}