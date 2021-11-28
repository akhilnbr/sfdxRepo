public class push {
    @AuraEnabled
    public static void insertPush(){
        PushTopic pushTopic = new PushTopic();
        pushTopic.Name = 'Account';
        pushTopic.Query = 'SELECT Id, Name FROM Account';
        System.debug('=============>'+pushTopic.Query);
        pushTopic.ApiVersion = 37.0;
        pushTopic.NotifyForOperationCreate = true;
        pushTopic.NotifyForOperationUpdate = true;
        pushTopic.NotifyForOperationUndelete = true;
        pushTopic.NotifyForOperationDelete = true;
        pushTopic.NotifyForFields = 'Referenced';
        insert pushTopic;
    }

}