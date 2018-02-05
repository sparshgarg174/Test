//Tset
public class ContactAndLeadSearch{
    public static List<List<SObject>> searchContactsAndLeads(String lname){
    
    List<List<sObject>> searchList = [FIND :lname IN NAME FIELDS 
    RETURNING Lead(Name,firstname,lastname ),Contact (name,firstname,lastname )];
    return searchList ;





 }

}