public class CaseRound {
    public static void assignTicketsRoundRobin(Set<Id> ticketIdsSet){
        List<Case> ticketList = [Select Id, OwnerId, CaseNumber__c 
                                 FROM 
                                 Case Where Id IN:ticketIdsSet];
        Integer index;
        Integer ticketNumber;
        Integer agentSize;
        List<User> userList = new List<User>();
        Set<Id> queueIdsSet = new Set<Id>();
        // Fetch Ids of the group.
        For(Case c : ticketList){
            If(String.valueOf(c.ownerId).startsWith('00G')){ //GET THE CASE WHERE OWNER IS QUEUE.GROUP starts with 00G
                queueIdsSet.add(c.ownerId);
            }
        }
        system.debug('queueIdsSet'+queueIdsSet);
        // return if Case is already assigned to user
        If(queueIdsSet==null || queueIdsSet.size()==0)return;
        
        Set<Id> userIdsSet = new Set<Id>();
        // Fetch Ids of the users
        For(GroupMember gm : [Select Id, UserOrGroupId 
                              FROM GROUPMEMBER 
                              WHERE GroupId IN : queueIdsSet]){
                                  userIdsSet.add(gm.UserOrGroupId);
                              }
        userList = [Select Id, Name,  Profile.Name 
                    From User 
                    WHERE Id In : userIdsSet 
                    AND ISACTIVE = true];
        system.debug('size'+userList.size());
        If(userList==null || userList.size()==0)return ;
        For(Case c : ticketList){
            if(c.CaseNumber__c!=null){
                ticketNumber = Integer.valueOf(c.CaseNumber__c);
                agentSize = userList.size();
                index = Math.MOD(ticketNumber ,agentSize);
                c.OwnerId = userList[index].id;
            }
        }
        If(ticketList!=null && ticketList.size()>0){   
            update ticketList;
        }
    }
}