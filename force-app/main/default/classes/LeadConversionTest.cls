@isTest
private  class LeadConversionTest {
    @isTest static void myTest() {
        lead newlead = new lead();
        newlead.LastName='ahaha';
        insert newlead;
        lead newlead1 = new lead();
        newlead1.LastName='aaaaa';
        insert newlead1;
    }
}