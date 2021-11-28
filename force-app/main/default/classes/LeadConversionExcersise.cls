public class LeadConversionExcersise {
    public static void getLeadList(list<lead> triggerleadlist)
    {
        boolean status= true;
        set<string> emailSet = new set<string>(); 
        set<string> phoneSet = new set<string>();
        set<string> nameSet = new set<string>();
        for(Lead triggerLeadObj : triggerleadlist)
        {
            emailSet.add(triggerLeadObj.Email); //adding email to the set
            phoneSet.add(triggerLeadObj.Phone); //adding phone number to the set
            nameSet.add(triggerLeadObj.LastName);
        }
        list<lead> duplicateLeadlist = [SELECT email,phone,id
                                        FROM lead 
                                        WHERE email in: emailSet 
                                        OR phone in:phoneSet  order by CreatedDate 
                                        asc limit 1]; // sele 
      
        Lead masterlead=[SELECT id,LastName,Email,Phone 
                         FROM Lead 
                         WHERE email IN:emailSet  OR phone IN: phoneSet
                         order BY CreatedDate 
                         DESC LIMIT 1];
        list<Lead> ConvertLeadToContact = [SELECT id, phone,lastname,IsConverted 
                                           FROM lead 
                                           where phone IN:phoneSet];
        LeadStatus convertStatus = [SELECT Id, MasterLabel  
                                    FROM LeadStatus WHERE IsConverted=true ];
        
        for(lead objLead:duplicateLeadlist)
        {
            if(objLead.id!=masterlead.id)
            {
                if(objLead.email==masterlead.email&&objLead.email!=null)
                {
                    Database.merge(masterlead, duplicateLeadlist, true);
                }
                
                else if(objLead.phone==masterlead.phone)
                {
                    system.debug('------------------------->');
                    Database.LeadConvert lc = new database.LeadConvert();
                    for(Lead objConvrtLedToContct:ConvertLeadToContact)
                    {
                        
                        if(status)
                        {
                            status=false;
                        }
                        
                        lc.setLeadId(objConvrtLedToContct.id);
                        lc.setConvertedStatus(convertStatus.MasterLabel);  
                        Database.LeadConvertResult lcr = Database.convertLead(lc);
                        System.assert(lcr.isSuccess());
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
}