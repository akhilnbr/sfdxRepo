public class item {
    @AuraEnabled
    public String label {get; set;}
    @AuraEnabled
    public String name {get; set;}
     @AuraEnabled
    public String rootContentFolderID {get; set;}
    @AuraEnabled
    public Boolean expanded {get; set;}
    @AuraEnabled
    public List<item> items {get; set;}
    
    public item(String label, String name, Boolean expanded, List<item> items,String rootContentFolderID){
        this.label = label;
        this.name = name;
        this.expanded = expanded;
        this.items = items;
        this.rootContentFolderID= rootContentFolderID;
        
    }
}