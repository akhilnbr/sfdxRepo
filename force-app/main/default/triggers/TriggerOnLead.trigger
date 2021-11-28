trigger TriggerOnLead on Lead (after insert) {
    LeadConversionExcersise.getLeadList(trigger.new);
}