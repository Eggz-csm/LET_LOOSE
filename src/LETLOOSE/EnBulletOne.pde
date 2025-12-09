class EnemyBullet { //Gabriel
  float x, y, vx, vy;
  float speed = 9;
  float radius = 6;
  int life = 240;
  boolean dead = false;

  EnemyBullet(float x, float y, float tx, float ty) {
    this.x = x;
    this.y = y;

    float angle = atan2(ty - y, tx - x);
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
  }

  void update() {
    x += vx;
    y += vy;
    life--;
    if (life <= 0) dead = true;
  }

  void display() {
    pushMatrix();
    translate(x, y);
    noStroke();
    fill(255, 60, 60);
    ellipse(0, 0, radius*2, radius*2);
    popMatrix();
  }
}
