class Player { // Gabriel- coding main (physics, collisions, and controls) | Ewan - coded flashing effects/splat, did art, andimations, and sounds

  final float SPLAT_VELOCITY = 25.0;
  final float HITBOX_DEFAULT_WIDTH = 25.0;

  int lastFrameTime = 0;
  int f = 1;

  // --- Position ---
  float x, y;

  // --- Hitbox (collision) ---
  float hitboxW = HITBOX_DEFAULT_WIDTH;
  float hitboxH = 70;

  // --- Sprite (rendering) ---
  float spriteW = 70;
  float spriteH = 78;

  // --- Movement ---
  float xVel, yVel;
  float gravity, jumpStrength;
  float ms;

  boolean moveLeft, moveRight;
  boolean isOnGround, getUp, gettingUp;
  boolean faceRight;
  boolean splatted;

  // --- Stamina ---
  float stamina = 100;
  float maxStamina = 140;

  // regeneration per frame
  float staminaRegen = 0.35; 
  int staminaRechargeDelay = 1000;
  int lastStaminaUse = 0;

  // costs
  float dashCost = 20;
  float wallJumpCost = 20;

  // --- Dash ---
  boolean dashing = false;
  boolean canDash = true;

  float dashSpeed = 18;
  int dashDuration = 200; // milliseconds
  int dashCooldown = 500;

  int dashStartTime = 0;
  int lastDashTime = -9999;

  // --- Wall Sliding / Wall Jump ---
  boolean wallSliding = false;
  boolean touchingWallLeft = false;
  boolean touchingWallRight = false;

  float wallSlideSpeed = 3.0;

  float wallJumpX = 10;
  float wallJumpY = -14;

  int wallJumpLockTime = 200;
  int wallJumpLockEnd = 0;

  int coyoteTime = 120; // milliseconds
  int lastGroundedTime = 0;

  boolean debugEnabled = false;

  boolean flashing = false;
  int flashDuration = 150; // stays flashed for flashduration milis
  int flashEndTime = 0; // when does the flash stop

  SoundFile splat;

  // --- Graphics ---
  Gif runGif;
  PImage still, getup1, getup2, getup3, dash, wallSlide;

  // --- Gun ---
  Gun gun;

  Player(PApplet app, SoundFile splat) {
    x = 0;
    y = 0;

    ms = 5;
    xVel = 0;
    yVel = 0;
    gravity = 0.8f;
    jumpStrength = -15;

    getUp = true;
    gettingUp = false;

    runGif  = new Gif(app, "Runguy.gif");
    runGif.play();

    still = loadImage("Stillguy.png");
    getup1 = loadImage("GetUp1.png");
    getup2 = loadImage("GetUp2.png");
    getup3 = loadImage("GetUp3.png");
    dash = loadImage("Dashguy2.png");
    wallSlide = loadImage("WallJumpGuy.png");

    this.splat = splat;

    gun = new Gun(this);
  }

  void update(ArrayList<Platform> platforms) {

    // --- Recharge stamina ---
    if (millis() - lastStaminaUse >= staminaRechargeDelay) {

      stamina += staminaRegen;
      stamina = constrain(stamina, 0, maxStamina);
    }
    // --- Dash timer ---
    if (dashing) {

      // Keep velocity constant during dash
      if (faceRight) xVel = dashSpeed;
      else xVel = -dashSpeed;

      // Optional: disable gravity during dash
      yVel = 0;

      // End dash
      if (millis() - dashStartTime >= dashDuration) {
        dashing = false;
      }
    }
    // --- Horizontal input ---
    if (!dashing) {

      // During wall jump lock,
      // ignore movement input
      if (millis() > wallJumpLockEnd) {

        if (moveLeft) xVel = -ms;
        else if (moveRight) xVel = ms;
        else xVel = 0;
      }
    }

    if (xVel == 0) {
      hitboxW = HITBOX_DEFAULT_WIDTH;
    } else {
      hitboxW = 50;
    }

    // --- Horizontal movement ---
    x += xVel;
    resolveHorizontalCollisions(platforms);

    // --- Apply gravity ---
    if (!dashing) {
      yVel += gravity;
    }

    checkWallSlide();

    // --- Step-based vertical movement to prevent tunneling ---
    float remainingY = yVel;
    int steps = ceil(abs(remainingY));          // one step per pixel
    if (steps == 0) steps = 1;                 // avoid division by zero
    float stepSize = remainingY / steps;

    for (int i = 0; i < steps; i++) {
      y += stepSize;
      resolveVerticalCollisions(platforms);
      // If player hits ground during steps, stop moving further
      if (isOnGround && stepSize > 0) {
        break;
      }
    }
    // Reset dash after cooldown
    if (!canDash && millis() - lastDashTime >= dashCooldown) {
      canDash = true;
    }
  }


  void resolveHorizontalCollisions(ArrayList<Platform> platforms) {
    // --- Pixel terrain ---
    if (xVel > 0 && isSolidPixel(x + hitboxW/2 + 1, y)) {
      while (isSolidPixel(x + hitboxW/2 + 1, y)) x--;
      xVel = 0;
    } else if (xVel < 0 && isSolidPixel(x - hitboxW/2 - 1, y)) {
      while (isSolidPixel(x - hitboxW/2 - 1, y)) x++;
      xVel = 0;
    }

    // --- Platform collisions ---
    for (Platform p : platforms) {
      if (!collidesWith(p)) continue;

      float overlapLeft   = (p.x + p.w) - (x - hitboxW/2);
      float overlapRight  = (x + hitboxW/2) - p.x;
      float overlapTop    = (y + hitboxH/2) - p.y;
      float overlapBottom = (p.y + p.h) - (y - hitboxH/2);

      float smallestHor = min(overlapLeft, overlapRight);
      float smallestVer = min(overlapTop, overlapBottom);

      if (smallestHor < smallestVer) {
        if (xVel > 0) x = p.x - hitboxW/2;
        else if (xVel < 0) x = p.x + p.w + hitboxW/2;
        xVel = 0;
      }
    }
  }

  void resolveVerticalCollisions(ArrayList<Platform> platforms) {
    boolean grounded = false;

    // --- Pixel terrain (falling) ---
    if (yVel > 0) {

      boolean boxHitGround = false;
      float hitX = x;

      float left = x - hitboxW/2;
      float right = x + hitboxW/2;

      // lower left
      if (isSolidPixel(left - 1, y + hitboxH/2 + 1)) {
        boxHitGround = true;
        hitX = left;
      } else if (isSolidPixel(right + 1, y + hitboxH/2 + 1)) {
        boxHitGround = true;
        hitX = right;
      }

      //if (isSolidPixel(x, y + hitboxH/2 + 1)) {
      if (boxHitGround) {
        float impactVel = yVel;
        //float gY = floorToSolidY(x, y + hitboxH/2);
        float gY = floorToSolidY(hitX, y + hitboxH/2);
        y = gY - hitboxH/2 + 0.5;

        if (abs(impactVel) >= SPLAT_VELOCITY) splatted = true;

        yVel = 0;
        grounded = true;
      }
    }
    // --- Pixel terrain (ceiling) ---
    else if (yVel < 0) {
      if (isSolidPixel(x, y - hitboxH/2 - 1)) {
        float cY = ceilToAirY(x, y - hitboxH/2);
        y = cY + hitboxH/2 - 0.5;
        yVel = 0;
      }
    }

    // --- Platform collisions ---
    for (Platform p : platforms) {
      if (!collidesWith(p)) continue;

      // --- Falling onto platform top ---
      if (yVel > 0 && (y - hitboxH/2) <= p.y && (y + hitboxH/2) >= p.y) {
        float impactVel = yVel;
        y = p.y - hitboxH/2 + 0.5;

        if (abs(impactVel) >= SPLAT_VELOCITY) {
          splatted = true;
        }
        yVel = 0;
        grounded = true;

        if (p.moving) {
          x += p.getDX();
          y += p.getDY();
        }
      }

      // --- Hitting platform bottom ---
      else if (yVel < 0 && (y + hitboxH/2) >= p.y + p.h && (y - hitboxH/2) <= p.y + p.h) {
        y = p.y + p.h + hitboxH/2 - 0.5;
        yVel = 0;
      }
    }

    // --- Final grounded state ---
    isOnGround = grounded;
    if (isOnGround) {
      y = round(y * 2) / 2.0;
      yVel = 0;
    }
    if (isOnGround) {
      lastGroundedTime = millis();
    }
  }

  boolean collidesWith(Platform p) {
    return (x + hitboxW/2 > p.x &&
      x - hitboxW/2 < p.x + p.w &&
      y + hitboxH/2 > p.y &&
      y - hitboxH/2 < p.y + p.h);
  }

  float floorToSolidY(float wx, float wy) {
    while (isSolidPixel(wx, wy)) wy--;
    return wy + 1 - 0.5;
  }

  float ceilToAirY(float wx, float wy) {
    while (isSolidPixel(wx, wy)) wy++;
    return wy - 1 + 0.5;
  }

  void checkWallSlide() {

    touchingWallLeft =
      isSolidPixel(x - hitboxW/2 - 2, y);

    touchingWallRight =
      isSolidPixel(x + hitboxW/2 + 2, y);

    // --- Wall slide condition ---
    wallSliding =
      !isOnGround &&
      yVel > 0 &&
      (
      (touchingWallLeft && moveLeft) ||
      (touchingWallRight && moveRight)
      );

    // --- Apply slide slowdown ---
    if (wallSliding) {

      yVel = min(yVel, wallSlideSpeed);

      // Optional: stick player to wall
      xVel = 0;
    }
  }

  void jump() {

    boolean canUseCoyote =
      millis() - lastGroundedTime <= coyoteTime;

    // --- Normal jump ---
    if (isOnGround || canUseCoyote) {

      yVel = jumpStrength;

      isOnGround = false;

      lastGroundedTime = -9999;
      return;
    }

    // --- Wall jump ---
    if (wallSliding) {

      if (stamina < wallJumpCost) return;

      stamina -= wallJumpCost;

      lastStaminaUse = millis();

      yVel = wallJumpY;

      if (touchingWallLeft) {
        xVel = wallJumpX;
        faceRight = true;
      } else if (touchingWallRight) {
        xVel = -wallJumpX;
        faceRight = false;
      }

      wallSliding = false;

      wallJumpLockEnd = millis() + wallJumpLockTime;
    }
  }

  void dash() {

    if (!canDash || dashing) return;

    if (stamina < dashCost) return;

    stamina -= dashCost;

    lastStaminaUse = millis();

    dashing = true;
    canDash = false;

    dashStartTime = millis();
    lastDashTime = millis();

    yVel = 0;

    if (faceRight) {
      xVel = dashSpeed;
    } else {
      xVel = -dashSpeed;
    }
  }

  void display() {
    pushMatrix();
    imageMode(CENTER);

    pushStyle();
    if (flashing && millis() <flashEndTime) {

      tint(255, 100, 100); // red
    } else {
      flashing = false;
    }

    // --- Getting up animation ---
    if (gettingUp) {
      if (millis() - lastFrameTime > 300) {
        f++;
        lastFrameTime = millis();
      }

      if (faceRight) {
        if (f == 1) image(getup1, x + 10, y-7, spriteW, spriteH);
        else if (f == 2) image(getup2, x + 10, y-7, spriteW, spriteH);
        else if (f == 3) image(getup3, x + 10, y-7, spriteW, spriteH);
        else {
          f = 1;
          gettingUp = false;
        }
      } else {
        scale(-1, 1);
        if (f == 1) image(getup1, -x + 5, y-7, spriteW, spriteH);
        else if (f == 2) image(getup2, -x + 5, y-7, spriteW, spriteH);
        else if (f == 3) image(getup3, -x + 5, y-7, spriteW, spriteH);
        else {
          f = 1;
          gettingUp = false;
        }
      }
    }

    // --- Dash animation ---
    if (dashing) {

      if (faceRight) {
        image(dash, x, y - 7, spriteW, spriteH);
      } else {
        scale(-1, 1);
        image(dash, -x, y - 7, spriteW, spriteH);
      }
    }

    // --- Wall Slide Animation ---
    else if (wallSliding) {

      if (touchingWallLeft) {

        scale(-1, 1);
        image(wallSlide, -x, y - 7, spriteW, spriteH);
      } else {

        image(wallSlide, x, y - 7, spriteW, spriteH);
      }
    }

    // --- Running / idle animation ---
    else {

      if (moveLeft) {
        scale(-1, 1);
        image(runGif, -x, y-7, spriteW, spriteH);
        faceRight = false;
      } else if (moveRight) {
        image(runGif, x, y-7, spriteW, spriteH);
        faceRight = true;
      } else {

        if (faceRight) image(still, x, y-7, spriteW, spriteH);
        else {
          scale(-1, 1);
          image(still, -x, y-7, spriteW, spriteH);
        }
      }
    }
    popStyle();
    popMatrix();

    // --- Gun on top ---d
    gun.display();

    // --- Trigger getting up after splat ---
    if (isOnGround && splatted && !gettingUp) {
      gettingUp = true;
      f = 1;
      lastFrameTime = millis();
      splatted = false;
      splat.play();
      flash();
      playerHP-= 10;
    }

    if (debugEnabled)
      drawDebugInfo();
  }

  void toggleDebug() {
    debugEnabled = !debugEnabled;

   // keep mouse coords synced with debug mode
    debugMousecoord = debugEnabled;
  }

  void drawDebugInfo() {
    // player coords
    textSize(16);
    fill(255);
    text(x, x, y+100);
    text(y, x+100, y+100);

    // hitbox
    noFill();
    stroke(255, 0, 0);
    rectMode(CENTER);
    rect(x, y, hitboxW, hitboxH);
  }
  void flash() {

    flashing = true;
    flashEndTime = millis() + flashDuration;
  }
}
