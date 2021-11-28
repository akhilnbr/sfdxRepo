trigger TrggerOnContentDocLink on ContentDocumentLink (after insert) {
AttachmentTask.TriggerTask(trigger.new);
}