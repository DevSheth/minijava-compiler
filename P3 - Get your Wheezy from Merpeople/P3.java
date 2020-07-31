import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P3 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         
         tablegenerator TG = new tablegenerator();
         Hashtable <String, classtable> SymbolTable = new Hashtable <String, classtable>();
         myobject O = new myobject();
         
         Object firstpass = root.accept(TG, SymbolTable); 
         
         O = (myobject) firstpass;

         IRGenerator IR = new IRGenerator();

         Object secondpass = root.accept(IR, O);

         // System.out.println(O.NewSymTab.get("A").MethDec.get("foo").index);
         // System.out.println(O.NewSymTab.get("A").MethDec.get("bar").index);
         // System.out.println(O.NewSymTab.get("B").MethDec.get("foo").index);
         // System.out.println(O.NewSymTab.get("B").MethDec.get("bar").index);
         // System.out.println(O.NewSymTab.get("B").MethDec.get("foobar").index);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
