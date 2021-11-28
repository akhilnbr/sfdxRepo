trigger TriggerRoundRobin on Case (after update) {
CaseRound.assignTicketsRoundRobin(Trigger.NewMap.keySet());
}