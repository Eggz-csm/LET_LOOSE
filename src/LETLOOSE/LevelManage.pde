class LevelManage {
  levTest lvt;
  boolean tl;
  LevelManage() {
    tl = true;
    lvt = new levTest();
  }
  void display() {
    if (tl) lvt.display();
  }
}
