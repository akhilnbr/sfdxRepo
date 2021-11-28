public class GetStudentList {
    public id idtoEdited {get; set;}
    public integer role{get;set;}
    public list<Student__c> listStudent ;
    public List<Student__c>  getStudent()
    {
        
        listStudent = Database.query('SELECT Name,Email__c,Course__c,Role_No__c,Phone__c from Student__c');
        return listStudent;
        
        
    }
    public void deleteStudent()
    {
        
        List<Student__c> deleteStudent = new List<Student__c>();
        deleteStudent = [select Role_No__c from Student__c where Role_No__c=:role];
        delete deleteStudent;
    }
    
    public void saveStudent()
    {
        Student__c student;
        
        for(Student__c selectStudent:listStudent)
        {
            if(selectStudent.Id==idtoEdited)
            {
                student = selectStudent;
                break;
            }
        }
        update student;
        idtoEdited=null;
        
    }
    
    
    
    
    
    
}