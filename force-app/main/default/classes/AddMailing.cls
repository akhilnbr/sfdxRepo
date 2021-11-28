public class AddMailing {
    
    public static void OnAfterInsert(List<Contact> newContact)
    {
        Map<Id,Contact> contactByAccountId = new Map<Id,Contact>(); 
        Set<Id> accountIdSet = new Set<Id>();
        for(contact objCon: newContact)
        {
            if(objCon.AccountId != null){
                contactByAccountId.put(objCon.AccountId, objCon);
                accountIdSet.add(objCon.AccountId);
            }
        }	
        
        list<Account> accountList = [select BillingAddress,BillingCity,BillingCountry,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode 
                                     from Account 
                                     where id =: accountIdSet];
        system.debug('this.is accountlist'+accountList);
        list<Account> updatedAccountList = new list<Account>();
        
        for(Account objAc : accountList){
            
            if(contactByAccountId.containsKey(objAc.Id)){
                system.debug('entering');
                Contact objCon = contactByAccountId.get(objAc.Id);
                objAc.BillingCity = objCon.MailingCity;
                objAc.BillingCountry = objCon.MailingCountry;
                objAc.BillingGeocodeAccuracy= objCon.MailingGeocodeAccuracy;
                objAc.BillingLatitude=objCon.MailingLatitude;
                objAc.BillingLongitude=objCon.MailingLongitude;
                objAc.BillingPostalCode= objCon.MailingPostalCode;
                objAc.BillingState=objCon.MailingState;
                objAc.BillingCountry=objCon.MailingCountry;
                updatedAccountList.add(objAc);
                
                
            }
        }
        update updatedAccountList;
        system.debug(updatedAccountList);
        
        
        
    }
    
}