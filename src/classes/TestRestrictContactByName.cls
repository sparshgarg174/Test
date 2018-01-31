@isTest
public class TestRestrictContactByName {
    static testMethod void RestrictContactByName1(){
        Contact c= new Contact();
        c.FirstName='ABC';
        c.LastName = 'INVALIDNAME';
        
        Test.startTest(); 
        Database.SaveResult result = Database.insert(c, false); 
        Test.stopTest(); 
       
     System.assert(!result.isSuccess()); 
      System.assert(result.getErrors().size() > 0); 
     System.assertEquals('The Last Name "'+c.LastName+'" is not allowed for DML', 
     result.getErrors()[0].getMessage()); 

    }
}