class LevelManage { // Gabriel
  
  levOne lv1;
  
  boolean l1;
  
  LevelManage(PApplet app) {
    l1 = true;
    lv1 = new levOne(app);
  }
  
  void display() {
    if (l1) {
      imageMode(CORNER);
      image(level1bg, level1X, level1Y, level1W, level1H);
      imageMode(CORNER);
      image(level1Img, level1X, level1Y, level1W, level1H);
      imageMode(CORNER);
      image(level1vis, level1X, level1Y, level1W, level1H);
      lv1.display();
    }
  }
}
