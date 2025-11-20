class LevelManage {
  levTest lvt;
  levOne lv1;
  boolean tl, l1;
  LevelManage() {
    //tl = true;
    //lvt = new levTest();
    l1 = true;
    lv1 = new levOne();
  }
  void display() {
    
    if (tl) {
      
      lvt.display();
    
    } else if (l1) {
    
    lv1.display();
    
  }
}
}
