trigger ContactTrigger on Contact (after insert) {
    
    	AddMailing.OnAfterInsert(trigger.New);
  

}