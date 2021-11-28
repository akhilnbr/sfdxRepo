public class ChechIFLeadIsDuplicated {
    public static void chechForDuplicatedLead(list<lead> newlead)
    {
        map<string,list<contact>> contactByEmail = new map<string,list<contact>>();
        Set<String> email = new Set<String>(), dupEmail = new Set<String>();
        for(contact objCon: [select id,name,email from contact])
        {
            if(contactByEmail.get(objCon.email)==null)
            {
                contactByEmail.put(objCon.email,new list<contact>());
            }
            contactByEmail.get(objCon.Email).add(objCon);
        }
        list<lead> leadsToDelete = new list<lead>();
       
        
    }
}