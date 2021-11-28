trigger triggerOnTask on Task (after insert,after update) {
    if(trigger.isInsert){
        triggerForTask.insertTask(trigger.new);
    }
    if(trigger.isUpdate){
        triggerForTask.updateTask(trigger.new);
    }
    
}