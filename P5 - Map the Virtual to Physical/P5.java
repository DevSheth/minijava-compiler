import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P5 {
   public static void main(String [] args) {
      try {
         Node root = new microIRParser(System.in).Goal();
         
         PickUpPoints PP = new PickUpPoints();
         labends O = new labends();
         
         Object firstpass = root.accept(PP, null); 
         
         O = (labends) firstpass;

         LivenessAnalysis LA = new LivenessAnalysis();
         table T = new table();

         Object secondpass = root.accept(LA, O);

         T = (table) secondpass;

         // System.out.println(T.LE.maxcounts.get("BBS_Sort"));
         // System.out.println(T.LT.get("BBS_Sort").in.get(1-1));
         // System.out.println(T.LT.get("BBS_Sort").def.get(1-1));
         // System.out.println(T.LT.get("BBS_Sort").succ.get(T.LT.get("BBS_Sort").out.size()-1));

         RegAlloc RA = new RegAlloc();

         Object thirdpass = root.accept(RA, T);

         // IRGenerator IR = new IRGenerator();

         // Object secondpass = root.accept(IR, O);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
