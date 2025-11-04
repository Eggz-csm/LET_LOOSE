class LevelManage {

  //Mem Var
  levTest lvt;
  boolean tl;
  //constructor
  LevelManage() {
    tl = true;
    lvt = new levTest();
  }
//Mem Methods
  void display() {
    if(tl==true) {
    lvt.display();
    }
  }
}

