import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P2 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         // System.out.println("Program parsed successfully");
         
         tablegenerator TG = new tablegenerator();
         Hashtable <String, classtable> SymbolTable = new Hashtable <String, classtable>();
         Object firstpass = root.accept(TG, SymbolTable); // Your assignment part is invoked here.
         
         SymbolTable = (Hashtable <String, classtable>) firstpass;

         typecheck TC = new typecheck();
         Object secondpass = root.accept(TC, SymbolTable);

         SymbolTable = (Hashtable <String, classtable>) secondpass;

         // System.out.println(SymbolTable.get("BS").VarDec.get("size"));
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
