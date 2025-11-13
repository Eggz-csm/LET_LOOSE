class Bullet {
  float x, y;
  float vx, vy;
  float speed = 12;
  float radius = 5;
  int life = 90; // frames
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
    // Optionally: check collision with platforms or bounds and set dead = true
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
