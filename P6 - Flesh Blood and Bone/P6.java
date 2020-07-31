import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P6 {
   public static void main(String [] args) {
      try {
         Node root = new MiniRAParser(System.in).Goal();
         
         Translator T = new Translator();
         root.accept(T, null);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
