global class LeadProcessor implements

Database.Batchable<sObject>,Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select LeadSource From Lead ]);
    }
    global void execute(Database.BatchableContext bc,list<lead> getLead){

            for(lead leadObj:getLead){
                 leadObj.LeadSource = 'Dreamforce';
            }

    }
    global void finish(Database.BatchableContext bc){
        
    }
    
}