public with sharing class GetFiles {
    @AuraEnabled
    public static List<sObject> getAllLibrary( ){
        
        return [Select id,Name From ContentWorkSpace];
    }
    @AuraEnabled
    public static List<sObject> getAllFolder( ){
        
        return [Select id,Name,parentcontentfolderid From ContentFolder];
    }
    @AuraEnabled
    public static List<sObject> getListOfAttachment( ){
        
        return [Select id,Title,FileExtension,Owner.Name,FileType,ContentSize From contentDocument];
    }
    
    @AuraEnabled
    public static list<item> getWorkSpace(){
        
        List<item> items = new List<item>();
        for(ContentWorkspace workSpaceObj : [SELECT Id, Name, RootContentFolderId 
                                             FROM ContentWorkspace]){
                                                 List<item> foldersList = new List<item>();
                                                 for(ContentFolder cfObj: [SELECT Id, Name, LastModifiedDate
                                                                           FROM ContentFolder
                                                                           WHERE ParentContentFolderId =:workSpaceObj.RootContentFolderId]){ 
                                                                               Item cfitem = new Item(cfObj.Name,String.valueOf(cfObj.Id),false,null,null);
                                                                               foldersList.add(cfitem);
                                                                           }
                                                 
                                                 Item cwsitem = new Item(workSpaceObj.Name,String.valueOf(workSpaceObj.Id),false,foldersList,workSpaceObj.RootContentFolderId);
                                                 items.add(cwsitem);
                                             }
        return items;
        
    }
    
    @AuraEnabled
    public static void saveFoldertoLibrary(string label,string libraryID){
        
        ContentWorkspace cw = [SELECT Id, Name
                               FROM ContentWorkspace
                               WHERE id =: libraryID
                              ];
        
        List < ContentFolderLink > cfl = [SELECT Id, ContentFolderId, ParentEntityId
                                          FROM ContentFolderLink
                                          WHERE ParentEntityId = : cw.Id
                                         ];
        
        if (cfl.size() > 0) {
            ContentFolder cf = new ContentFolder(Name = label, ParentContentFolderId = cfl[0].ContentFolderId);
            Insert cf;
        }
        
    }
    
    @AuraEnabled
    public static void fileUpload(string fileName,string libraryID){
        system.debug('fileName'+fileName);
        system.debug('fileName'+libraryID);
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation='E';
        conVer.PathOnClient=fileName+'.png';
        conVer.Title = fileName;
        
    }
    
    @AuraEnabled
    public static list<SObject> getFolderAndFile(string idOfLibrary ){
        
        list <sobject> appendList = new list<SObject>();
        set<id> setOfWorkSpaceId = new set<id>();
        list<ContentWorkspace> ContentWorkspace = [SELECT id 
                                                   FROM contentworkspace];
        for(ContentWorkspace obj:ContentWorkspace){
            setOfWorkSpaceId.add(obj.Id);
        }
        if(setOfWorkSpaceId.contains(idOfLibrary)){
            ContentWorkspace cw = [SELECT Id,Name,RootContentFolderId
                                   FROM ContentWorkspace
                                   WHERE id =: idOfLibrary
                                  ];
            if(cw.id!=null){
                
                list<SObject> listOfDocument= [SELECT ID,title 
                                               FROM contentdocument 
                                               WHERE parentid=:cw.Id];
                
                list <sobject> folderList = [SELECT Name,parentcontentfolderid
                                             FROM contentfolder 
                                             WHERE parentcontentfolderid=:cw.RootContentFolderId];
                appendList.addall(folderList);
                appendList.addall(listOfDocument);
                
            }
            
        }
        else
        {
            system.debug('>>>>>>>>>>>>>>'+idOfLibrary);
            set<id> folderMemberID = new set<id>();
            ContentFolder cf = [SELECT id,name,parentcontentfolderid 
                                FROM contentfolder 
                                WHERE id=:idOfLibrary];
            list<contentfoldermember>  folderMemberList= [ SELECT childrecordid,parentcontentfolderid 
                                                          FROM contentfoldermember 
                                                          WHERE parentcontentfolderid =:cf.id];
            for(contentfoldermember memberObj:folderMemberList){
                folderMemberID.add(memberObj.childrecordid);
            }
            
            list<SObject> getDocument = [SELECT title ,ContentDocumentId 
                                         FROM contentversion 
                                         WHERE ContentDocumentId IN:folderMemberID];
            
            appendList.addall(getDocument);
        }
        system.debug('sppendList'+appendList);
        
        return appendList;
    }
    @AuraEnabled
    public static list<ContentDocument> searchDocument(string searchKeyWord){
        String searchKey = searchKeyWord + '%';
        system.debug('searchKey'+searchKey);
        list<ContentDocument> returnList = new list<ContentDocument>();
        list<ContentDocument> searchRecord = [SELECT id,Owner.Name,title,filetype,FileExtension 
                                              FROM ContentDocument 
                                              WHERE title LIKE:searchKey LIMIT 10];
        for(ContentDocument docObj:searchRecord){
            returnList.add(docObj);
        }
        system.debug('returnList'+returnList);
        return returnList;
    }
    @AuraEnabled
    public static Boolean uploadFile(String docId,string parentId) {
        
            ContentFolderMember folderMember = [SELECT Id, ParentContentFolderId,ChildRecordId 
                                                from ContentFolderMember where ChildRecordId = :docId limit 1]; //file uploaded
            
            ContentFolder folder = [SELECT Id, name,ParentContentFolderId 
                                    from contentfolder 
                                    where Id =: parentId limit 1];
            folderMember.ParentContentFolderId = folder.Id;
            update folderMember;
            return true;
        
    }
    
    
    
    
}