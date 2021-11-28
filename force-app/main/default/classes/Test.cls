public class Test {
    public string label{get;set;}
    public string value{get;set;}
    public Test(SelectOption op)
    { 
        system.debug('>>>>>');
        this.value = op.getValue();
        this.label = op.getLabel();
    }
}