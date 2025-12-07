class Bullet {
  float x, y;
  float vx, vy;
  float speed = 25;
  float radius = 5;
  int life = 90;
  int dmg = 1;
  boolean dead = false;

  Bullet(float x, float y, float angle) {
    this.x = x;
    this.y = y;
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
  }

  void update() {
    x += vx;
    y += vy;
    life--;
    if (life <= 0) dead = true;

    // Collision with carls
    for (int i = carls.size()-1; i >= 0; i--) {
      Carl c = carls.get(i);
      if (dist(x, y, c.x, c.y) < 40) {
        c.damage(dmg);
        dead = true;
        break;
      }
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    noStroke();
    fill(255, 220, 60);
    ellipse(0, 0, radius*2, radius*2);
    popMatrix();
  }
}

