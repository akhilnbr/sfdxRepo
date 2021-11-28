public class sear{
    public string label{get;set;}
    public string value{get;set;}
    public sear(SelectOption op){ 
        this.value = op.getValue();
        this.label = op.getLabel();
    }
}