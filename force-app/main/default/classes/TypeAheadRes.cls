public with sharing class TypeAheadRes {
    @AuraEnabled
  public String rId {get;set;}

  @AuraEnabled
  public String rName {get;set;}

  public TypeAheadRes(String rId, String rName)
  {
    this.rId   = rId;
    this.rName = rName;
  }
}