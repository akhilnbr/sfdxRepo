trigger leadCreateTrigger on Lead (before insert) {
    ChechIFLeadIsDuplicated.chechForDuplicatedLead(trigger.new);

}