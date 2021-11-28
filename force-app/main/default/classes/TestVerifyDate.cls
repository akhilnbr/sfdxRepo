@isTest
public class TestVerifyDate {
    @isTest static void testName() {
        Date startDate1 = date.newInstance(2015, 12, 15);
        Date endDate1 = date.newInstance(2015, 12, 30);
        Date startDate2 = date.newInstance(2016, 12, 30);
        date endDate2 = date.newInstance(2013, 12, 15);
        if(startDate1 < endDate1)
        {
        boolean checkError = VerifyDate.DateWithin30Days(startDate1, endDate1);
        date checkDate = VerifyDate.CheckDates(startDate1, endDate1);
        date SetEndOfMonthDate = VerifyDate.SetEndOfMonthDate(checkDate);
        
        }
        if(startDate2 > endDate2)
        {
            boolean checkError = VerifyDate.DateWithin30Days(startDate2, endDate2);
        date checkDate = VerifyDate.CheckDates(startDate2, endDate2);
        date SetEndOfMonthDate = VerifyDate.SetEndOfMonthDate(checkDate);
        
        }
        
        
    }
    
    
}