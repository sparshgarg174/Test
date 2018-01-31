public class ContactSearch{
    public static List<Contact> searchForContacts(String lname,String postal){
    List<Contact> lcon=new List<Contact>();
    if(lname!='' || postal!=''){
        for (Contact con :[select id,name,MobilePhone from contact c where c.lastname=:lname and c.MailingPostalCode=:postal]){
            lcon.add(con);
       
        }
    }
    return lcon;
  }

}