class Gun {
  Player p;
  float angle = 0;
  float length = 35;   // how far barrel extends from player center
  float thickness = 8; // visual thickness
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
    fill(80);
    // Draw barrel (rectangle). Draw from player center to the right (0..length)
      rectMode(CORNER);
    // shift upward so it's centered vertically
    //rect(offsetRadius, -thickness/2, length, thickness, 3);
    // draw small muzzle
    fill(200,160,50);
    rect(offsetRadius + length, -thickness/2 - 2, 6, thickness + 4, 2);
    popMatrix();
  }

  void fire(float targetX, float targetY, ArrayList<Bullet> bullets) {
    // spawn bullet at muzzle position (world)
    float muzzleX = p.x + cos(angle) * (offsetRadius + length + 6); // a bit ahead of barrel
    float muzzleY = p.y + sin(angle) * (offsetRadius + length + 6);
    bullets.add(new Bullet(muzzleX, muzzleY, angle));
  }
}
