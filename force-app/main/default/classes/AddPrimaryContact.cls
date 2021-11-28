public class AddPrimaryContact implements Queueable {
    private Contact objContact;
    private string Abbreviation;
    public AddPrimaryContact(Contact obj,string abv){
        this.objContact= obj;
        this.Abbreviation = abv;
        
    }
    public void execute(QueueableContext context){
        list<Account> getAccountList= [SELECT NAME,BillingState,(SELECT id,FirstName,LastName from contacts) 
                                       FROM Account WHERE BillingState=:Abbreviation LIMIT 200 ];
        list<Contact> udpateContact = new list<contact>();
        for(Account objAccount:getAccountList)
        {
            Contact contObj = objContact.clone(false,false,false,false);
            contObj.AccountId = objAccount.Id;
            udpateContact.add(contObj);

        }
        if(udpateContact.size()>0){
            INSERT	udpateContact;
        }
            
        
    }
    
}