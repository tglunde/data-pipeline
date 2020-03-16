
import java.lang.reflect.*;

public class ClassDemoJDK11 {

   public static void main(String[] args) {

     try {            
         ClassDemoJDK11 c = new ClassDemoJDK11();
         Class cls = c.getClass();

         // field long l
         Field[] lVal  = cls.getDeclaredFields();
         System.out.println("Field = " + lVal.toString());
      } catch(Exception e) {
         System.out.println(e.toString());
      }
   }

   public ClassDemoJDK11() {
      // no argument constructor
   }

   public ClassDemoJDK11(long l) {
      this.l = l;
   }

   long l = 77688;
   int i = 0;
}
