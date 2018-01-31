public class StringArrayTest
{
    
    public static List<string> generateStringArray(Integer i){
        integer index;
        List<string> lsttest = new List<String>();
        for(index=0 ;index<i; index++){
          lsttest.add('Test '+index);
        }
        return lsttest;
     }
    
}