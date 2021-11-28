public class apexForTest {
    public list<Account> accounts {set;get;}
    public List<Account> myList {set;get;}
    public apexForTest(){
        myList=[select Id,Name,Phone,Industry,Rating,Ownership from Account];
        accounts=new list<Account>();
        accounts.addAll(myList);
    }    
}