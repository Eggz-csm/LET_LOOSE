class Player {
  float x, y, w, h;
  float xVel, yVel;
  float gravity, jumpStrength;
  boolean moveLeft, moveRight;
  boolean isOnGround, faceRight;
  float ms;
  Gif runGif;
  PImage still;
  Gun gun; // ← gun attached to player

  Player(PApplet app) {
    x = width / 2;
    y = 400;
    w = 50;
    h = 50;
    ms = 5;
    xVel = 0;
    yVel = 0;
    gravity = 0.8;
    jumpStrength = -15;
    runGif  = new Gif(app, "RunGuy.gif");
    runGif.play();
    still = loadImage("Stillguy.png");
    gun = new Gun(this); // create gun bound to player
  }

  void display() {
    pushMatrix();
    imageMode(CENTER);
    if (moveLeft) {
      scale(-1, 1);
      image(runGif, -x, y, w, w);
      faceRight = false;
    } else {
      if (moveRight) {
        image(runGif, x, y, w, w);
        faceRight = true;
      } else {
        if (faceRight) {
          image(still, x, y, w, w);
        } else {
          scale(-1, 1);
          image(still, -x, y, w, w);
        }
      }
    }
     popMatrix();
        // Draw gun AFTER player sprite so it sits on top
        gun.display();
  }


  void update(ArrayList<Platform> platforms) {
    // --- Move with moving platforms BEFORE gravity ---
    if (isOnGround) {
      for (Platform p : platforms) {
        if (collidesWith(p) && p.moving) {
          x += p.getDX();
          y += p.getDY();
        }
      }
    }

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

  void resolveHorizontalCollisions(ArrayList<Platform> platforms) {
    for (Platform p : platforms) {
      if (collidesWith(p)) {
        float overlapRight = (x + w/2) - p.x;
        float overlapLeft  = (p.x + p.w) - (x - w/2);
        float overlapYTop  = (y + h/2) - p.y;
        float overlapYBottom = (p.y + p.h) - (y - h/2);

        if (abs(overlapRight) < abs(overlapYTop) && abs(overlapLeft) < abs(overlapYBottom)) {
          continue;
        }

        if (xVel > 0) {
          x = p.x - w/2; // moving right, hit platform left side
        } else if (xVel < 0) {
          x = p.x + p.w + w/2; // moving left, hit right side
        }
      }
    }
  }

  void resolveVerticalCollisions(ArrayList<Platform> platforms) {
    boolean groundedThisFrame = false;

    for (Platform p : platforms) {
      if (collidesWith(p)) {
        // Falling DOWN onto platform (solid top)
        if (yVel > 0 && (y - h/2) < p.y) {
          y = p.y - h/2;
          yVel = 0;
          groundedThisFrame = true;
          if (p.moving) {
            x += p.getDX();
            y += p.getDY();
          }
        }
        // Jumping UP into platform
        else if (yVel < 0 && (y + h/2) > (p.y + p.h)) {
          y = p.y + p.h + h/2;
          yVel = 0;
        }
      }
    }

    isOnGround = groundedThisFrame;
    if (isOnGround && abs(yVel) < 0.1) yVel = 0;
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
