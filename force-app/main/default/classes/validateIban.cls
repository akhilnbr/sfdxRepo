public class validateIban {
    public static Boolean validateIbanNumber(String iban) {
        
        Boolean res = true;
        String ibanRegex = '^([A-Z]{2}[ '+'\\'+'-]?[0-9]{2})(?=(?:[ '+'\\'+'-]?[A-Z0-9]){9,30}$)((?:[ '+'\\'+'-]?[A-Z0-9]{3,5}){2,7})([ '+'\\'+'-]?[A-Z0-9]{1,3})?$'; 
        Pattern MyPattern = Pattern.compile(ibanRegex);
        if(iban!=null){
            Matcher MyMatcher = MyPattern.matcher(iban);
            if (!MyMatcher.matches()) 
            {
                system.debug('>>>>>>>');
                res = false;
            }
            
        }
        system.debug('res'+res);
        
        return res; 
    }
    
}