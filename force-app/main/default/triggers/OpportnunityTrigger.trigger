trigger OpportnunityTrigger on Opportunity (after insert) {
CreateATaskOnOpportunityTrigger.createNewTask(trigger.new);
}