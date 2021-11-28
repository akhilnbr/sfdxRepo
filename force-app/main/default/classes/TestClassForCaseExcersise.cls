@istest
private class TestClassForCaseExcersise {
    @istest static void mytest(){
        list<case> idset= new list<case>();
        for(integer i=0;i<100;i++){
          idset.add(new case(Status='New',origin='Phone'));
        }
        INSERT idset;
    }
}