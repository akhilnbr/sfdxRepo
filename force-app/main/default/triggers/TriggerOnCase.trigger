trigger TriggerOnCase on Case (after insert) {
    CaseExcersise.updateSubject(trigger.new);
     CaseExcersise.checkForContactorAccountInCase(trigger.new);
}