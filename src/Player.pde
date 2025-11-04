class Player {
  //Member Variables
  int x, y, w, h;

  //Constructor
  Player() {
    x = int(random(width));
    y = 50;
    w = int(random(10, 100));
    h = 50;
  }

  //Member Methods
  void display() {
    rectMode(CENTER);
    rect(50, 50, x, y);
  }
  
  void move(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
}
