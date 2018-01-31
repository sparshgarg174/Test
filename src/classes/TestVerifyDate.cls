@isTest
public class TestVerifyDate {
 @istest   static void CheckDatestest1(){
     		Date par1=Date.newInstance(2017, 08, 20);
     		Date par2=Date.newInstance(2017, 08, 21);
    	     Date date1 = VerifyDate.CheckDates(par1,par2);
     		Date date2= Date.newInstance(2017, 08, 21);
	        System.assertEquals(date2, date1);
    }
 @istest   static void CheckDatestest2(){
     		Date par1=Date.newInstance(2017, 08, 20);
     		Date par2=Date.newInstance(2017, 10, 21);
     		Date date2= Date.newInstance(2017, 08, 31);
    	     Date date1 = VerifyDate.CheckDates(par1,par2);
	        System.assertEquals(date2, date1);
    }
}