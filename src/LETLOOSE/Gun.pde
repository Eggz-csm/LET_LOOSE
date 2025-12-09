class Gun { //Gabriel
  Player p;
  float angle = 0;
  float length = 45;   // how far barrel extends from player center
  float thickness = 2; // visual thickness
  float offsetRadius = 0; // if you want the gun to orbit slightly away from center

  Gun(Player p) {
    this.p = p;
  }

  void update(float targetX, float targetY) {
    // angle pointing from player center to mouse in world coords
    angle = atan2(targetY - p.y, targetX - p.x);
  }

  void display() {
    pushMatrix();
    translate(p.x, p.y); // player center in world coords
    rotate(angle);
    noStroke();
    rectMode(CORNER);
    fill(200, 90, 130);
    rect(offsetRadius + length, -thickness/2 - 2, 8, thickness, 1);
    popMatrix();
  }

  void fire(float targetX, float targetY, ArrayList<Bullet> bullets) {
    // spawn bullet at muzzle position (world)
    float muzzleX = p.x + cos(angle) * (offsetRadius + length + 6); // a bit ahead of barrel
    float muzzleY = p.y + sin(angle) * (offsetRadius + length + 6);
    bullets.add(new Bullet(muzzleX, muzzleY, angle));
    sf+=1;
  }
}
