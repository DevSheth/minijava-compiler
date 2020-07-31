import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P4 {
   public static void main(String [] args) {
      try {
         Node root = new MiniIRParser(System.in).Goal();

         microIRgen MG = new microIRgen();
         root.accept(MG, null);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
