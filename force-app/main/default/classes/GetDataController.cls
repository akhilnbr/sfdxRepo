public class GetDataController {
    
    @AuraEnabled
    public static List < string > fetchLookUpValues() {
        
        
        List <string> lstOfRecords = new list<string>();
        for (ServiceArea__c obj: [select state__c from ServiceArea__c ]) {
            if(!lstOfRecords.contains(obj.state__c))
            {
                lstOfRecords.add(obj.state__c);
            }
        }
        
        return lstOfRecords;
    }
    @AuraEnabled
    public static list<string> getCountie(String statename  )
    {
        list<string> listofCounty = new list<string>();
        for(ServiceArea__c obj: [select county__c from ServiceArea__c where state__C =:statename])
        {
            if(listofCounty.contains(obj.county__c))
            {
                
            }
            else
            {
                listofCounty.add(obj.county__c);
                
            }
            
        }
        system.debug('--------'+listofCounty);
        return listofCounty;
    }
    @AuraEnabled
    public static list<string> getCityList(string county,list<string> ExcludeitemsList)
    {
        system.debug('county'+county);
        list<string> listofCity = new list<string>();
        
        for(ServiceArea__c obj: [select city__c from ServiceArea__c where county__c =:county ])
        {
            
            
            if(listofCity.contains(obj.city__c))
            {  
            }   
            else
            {
                listofCity.add(obj.city__c);
            }
        }
        system.debug('city'+listofCity);
        return listofCity;
        
    }
    @AuraEnabled
    public static void SaveServiceArea(string state,string county,string city,string reId)
    {
        string updateMessage = '';
        list<lead> updateLead = new list<lead>();
        for(lead obj:[select P_State__c,P_County__c,P_city__c from lead where id =:reId])
        {
            if(reId!=null)
            {
                obj.P_State__c = state;
                obj.P_County__c = county;
                obj.P_city__c = city;
                updateLead.add(obj);
            }
        }
        update updateLead;
    }
    
}