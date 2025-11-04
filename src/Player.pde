class Player {
  //Member Variables
  int x, y, w, h, ms;
  boolean moveLeft = false;
  boolean moveRight = false;
  //Constructor
  Player() {
    x = int(random(width));
    y = 50;
    w = int(random(10, 100));
    h = 50;
    ms = 5;
  }

  //Member Methods
  void display() {
    rectMode(CENTER);
    rect(x, y, 50, 50);
  }

  void move(int x, int y) {
    this.x = x;
    this.y = y;
  }
}
