@isTest
private class LeadProcessorTest {
      @isTest static void processTesting() {
      List<Lead> lstLead = new List<Lead>();
        for(Integer i=0 ;i <100;i++)
        {
            Lead led = new Lead();
            led.FirstName ='FirstName';
            led.LastName ='LastName'+i;
            led.Company ='demo'+i;
            lstLead.add(led);
        }
        for(Integer j=0 ;j <100;j++)
        {
            Lead led = new Lead();
            led.FirstName ='FirstName';
            led.LastName ='LastName'+j;
            led.Company ='demo'+j;
            lstLead.add(led);
        }
        insert lstLead;
        
        Test.startTest();

            LeadProcessor obj = new LeadProcessor();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}