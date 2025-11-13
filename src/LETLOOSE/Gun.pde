class Gun {
  float x;
  float y;

  float vx;
  float vy;

  //laser look
  float speed =15;
  float length =30;
  float thickness = 4;
  color laserColor = color(93, 243, 255);

  //constructor
  Gun(float startX, float startY, float targetX, float targetY) {
    this.x = startX;
    this.y = startY;
    //calc the vector from player to mouse
    float dx = targetX -startX;
    float dy = targetY -startY;
    //calc distance
    float distance = sqrt(dx*dx + dy*dy);

    if (distance>0) {
      this.vx =(dx/distance)*speed;
      this.vy=(dy/distance) *speed;
    } else {
      this.vx =0;
      this.vy =-speed;
    }
  }

  void move() {
    x+= vx;
    y+= vy;
  }

  void display() {
    stroke(laserColor);
    strokeWeight(thickness);
    line(x, y, x-vx*(length/speed), y-vy*(length/speed));
  }

  boolean isOffScreen() {
    float margin =50;
    return x< camX - margin || x>camX +width + margin ||
      y <camY - margin || y> camY + height + margin;
  }
}
