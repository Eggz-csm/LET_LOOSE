class Gun {
  //Member Variables
  int x, y, w, h, speed;

  //Constructor
  Gun(int x, int y) {
    this.x = x;
    this.y = y;
    w = 6;
    h = 12;
speed = 5; 
  }

  //Member Methods
  void display() {
    ellipse(20, 20, x, y);
  }

  void move() {
    y = y - speed;
  }
}
