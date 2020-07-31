class LinkedList{
    public static void main(String[] a){
	System.out.println(new C().GetSalary1());
    }
}

class A extends B{
    int xa;
  public int GetSalary()
  {
	   return xb ;
  }
  public int GetSalary1()
  {
	   return xa ;
  }
  public int GetSalary2()
  {
	   return xb ;
  }
}

class B{
  int xb;
  int xe;
  public int GetSalary(){
      return xb ;
  }
}

class C extends D{
  int xc;
  public int GetSalary(){
	   return xa ;
    }
    public int GetSalary2()
    {
  	   return xb ;
    }
}

class D extends A{
    int xd;

    public int GetSalary(){
	       return xb ;
    }
    public int GetSalary2()
    {
  	   return xa ;
    }
}
