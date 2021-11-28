@isTest
private class TestClassForTesting {
    @isTest static void testTaskOnOpportunity()
    {
        list<opportunity> opppList = new list<opportunity>{
            new Opportunity( Name='Test900', StageName='Prospecting', closedate=System.now().date().addDays(6),Amount=200,Type='Existing Customer-upgrade'),
                new Opportunity( Name='Test700', StageName='Prospecting', closedate=System.now().date().addDays(5),Amount=400,Type='Existing Customer-upgrade'),
                new Opportunity( Name='Test600', StageName='Prospecting', closedate=System.now().date().addDays(7),Amount=300,Type='Existing Customer-upgrade'),
                new Opportunity( Name='Test500', StageName='Prospecting', closedate=System.now().date().addDays(8),Amount=200,Type='Existing Customer-upgrade')
                };
                    
                    insert opppList;
        
        System.assertEquals(4,[select count() from task]);
    }
    
    
}