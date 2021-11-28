public with sharing class TypeaheadFunction {
    public static TypeAheadRes[] srch(String rName, String sObjName, String filterField,String filter)
    {
        if(sObjName=='User')
        {
            system.debug('user');
            filter = 'IsActive = true';
        }
        
        TypeAheadRes[] resList = new TypeAheadRes[]{};
            if(sObjName=='Account')
        {
            system.debug('account');
            String sanitizedSearchString = String.escapeSingleQuotes(rName);
            String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjName);
            
            String searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN NAME FIELDS RETURNING ' + sanitizedSObjectAPIName + '(Id,Name) Limit 15'; 
            
            List<List<SObject>> searchList = search.query(searchQuery);
            system.debug('searchList'+searchList);
            for (SObject so : searchList[0]) {
                resList.add(new TypeAheadRes(so.Id, (String)so.get('Name')));
                //results.add(new Result((String)so.get('Name'), so.Id));
            }
        }
        else
        {
            system.debug('>><>>>else');
            //filterField = 'accountId';
            system.debug('filterField'+filterField);
            rName = rName.replaceAll('\'', '\\\\\'');
            System.debug('filterStr: '+filter);
            
            string filterStr='';
            
            sObject[] tempList = Database.query('Select Id,Name From '+
                                          sObjName +
                                          ' WHERE Name Like \'%' + rName + '%\''+
                                          ((filterField!=null&&filterField!='')?(' AND '+ filterField):'')+
                                           ((filter!=null&&filter!='')?(' = \''+ filter+'\''):'')+
                                          ' LIMIT 5');
         
            
            system.debug('tempList'+tempList);
            for(sObject s : tempList)
            {
                String realName = (String)s.get('Name');
                
                resList.add(new TypeAheadRes((Id)s.get('Id'), realName));
            }
        }
        return(resList);
    }
    
}