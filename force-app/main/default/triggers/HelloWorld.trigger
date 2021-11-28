trigger HelloWorld on Account (before insert) {
	for(Account obj: Trigger.New)
    {
        obj.description='This is a new description';
    }
}