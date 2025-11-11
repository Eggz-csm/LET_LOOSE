class Platform {
  float x, y, w, h;
  color c1;
  float xVel, yVel;
  float minX, maxX, minY, maxY;
  boolean moving;
  float prevX, prevY;

  // Static platform
  Platform(float x, float y, float w, float h, color c1) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c1 = c1;
    moving = false;
    prevX = x;
    prevY = y;
  }

  // Moving platform
  Platform(float x, float y, float w, float h, color c1,
           float xVel, float yVel, float minX, float maxX, float minY, float maxY) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c1 = c1;
    this.xVel = xVel;
    this.yVel = yVel;
    this.minX = minX;
    this.maxX = maxX;
    this.minY = minY;
    this.maxY = maxY;
    this.moving = true;
    prevX = x;
    prevY = y;
  }

  void update() {
    prevX = x;
    prevY = y;

    if (moving) {
      x += xVel;
      y += yVel;

      // Reverse direction at bounds
      if (x < minX || x + w > maxX) xVel *= -1;
      if (y < minY || y + h > maxY) yVel *= -1;
    }
  }

  void display() {
    fill(c1);
    rectMode(CORNER);
    rect(x, y, w, h);
  }

  // Movement delta getters for player syncing
  float getDX() { return x - prevX; }
  float getDY() { return y - prevY; }
}
