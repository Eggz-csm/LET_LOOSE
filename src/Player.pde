class Player {
  float x, y, w, h;
  float xVel, yVel;
  float gravity, jumpStrength;
  boolean moveLeft, moveRight;
  boolean isOnGround;
  float ms;

  Player() {
    x = width / 2;
    y = 100;
    w = 50;
    h = 50;
    ms = 5;
    xVel = 0;
    yVel = 0;
    gravity = 0.8;
    jumpStrength = -15;
  }

  void display() {
    fill(255, 100, 100);
    rectMode(CENTER);
    rect(x, y, w, h);
  }

  void update(ArrayList<Platform> platforms) {
    // --- Apply player input ---
    if (moveLeft)  xVel = -ms;
    else if (moveRight) xVel = ms;
    else xVel = 0;

    // --- Horizontal Movement ---
    x += xVel;
    resolveHorizontalCollisions(platforms);

    // --- Apply Gravity ---
    yVel += gravity;
    y += yVel;

    // --- Vertical Movement ---
    resolveVerticalCollisions(platforms);
  }

  // --- Handle horizontal collisions only ---
  void resolveHorizontalCollisions(ArrayList<Platform> platforms) {
    for (Platform p : platforms) {
      if (collidesWith(p)) {
        // Moving right into platform’s left edge
        if (xVel > 0) {
          x = p.x - w/2;
        }
        // Moving left into platform’s right edge
        else if (xVel < 0) {
          x = p.x + p.w + w/2;
        }
      }
    }
  }

  // --- Handle vertical collisions only ---
  void resolveVerticalCollisions(ArrayList<Platform> platforms) {
    boolean groundedThisFrame = false;

    for (Platform p : platforms) {
      if (collidesWith(p)) {
        // Falling down onto platform
        if (yVel > 0) {
          y = p.y - h/2;
          yVel = 0;
          groundedThisFrame = true;
        }
        // Jumping up into platform
        else if (yVel < 0) {
          y = p.y + p.h + h/2;
          yVel = 0;
        }
      }
    }

    isOnGround = groundedThisFrame;
  }

  boolean collidesWith(Platform p) {
    return (x + w/2 > p.x &&
            x - w/2 < p.x + p.w &&
            y + h/2 > p.y &&
            y - h/2 < p.y + p.h);
  }

  void jump() {
    if (isOnGround) {
      yVel = jumpStrength;
      isOnGround = false;
    }
  }
}
