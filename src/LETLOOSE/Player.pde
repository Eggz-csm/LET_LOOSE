class Player {

  
  final float SPLAT_VELOCITY = 25.0;
  
  
  int lastFrameTime = 0;
  int f = 1;
  float x, y, w, h;
  float xVel, yVel;
  float gravity, jumpStrength;
  boolean moveLeft, moveRight;
  boolean isOnGround, getUp, gettingUp;
  boolean faceRight;
  boolean splatted;
  float ms;
  Gif runGif;
  PImage still, getup1, getup2, getup3;
  Gun gun; // ← gun attached to player

  Player(PApplet app) {
    x = 0;
    y = 0;
    w = 50;
    h = 50;
    ms = 5;
    xVel = 0;
    yVel = 0;
    gravity = 0.8;
    jumpStrength = -15;

    getUp = true;
    gettingUp = false;

    runGif  = new Gif(app, "Runguy.gif");
    runGif.play();

    still = loadImage("Stillguy.png");

    getup1 = loadImage("GetUp1.png");
    getup2 = loadImage("GetUp2.png");
    getup3 = loadImage("GetUp3.png");


    gun = new Gun(this); // create gun bound to player
  }

  void display() {
    pushMatrix();
    imageMode(CENTER);

    
    if (gettingUp) {
      if (millis() - lastFrameTime > 300) {  // 0.2s per frame
        f++;
        lastFrameTime = millis();
      }

      if (faceRight) {
       
      if (f == 1)      image(getup1, x+10, y, w, w);
      else if (f == 2) image(getup2, x+10, y, w, w);
      else if (f == 3) image(getup3, x+10, y, w, w);
      
      else {
        f = 1;              // reset
        gettingUp = false;  // animation done
      }
      
    } else {
      
      scale(-1, 1);
      
      if (f == 1)      image(getup1, -x+5, y, w, w);
      else if (f == 2) image(getup2, -x+5, y, w, w);
      else if (f == 3) image(getup3, -x+5, y, w, w);
      
      else {
        f = 1;              // reset
        gettingUp = false;  // animation done
      }
    }
      
    } else {

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
    }
    popMatrix();

    if (isOnGround) {

      if (splatted) {
      if (!getUp) {

        getUp = true;
        gettingUp = true;
        f = 1;
        lastFrameTime = millis(); 
        
        splatted = false;
        
        }
      }
    } else {

      getUp = false;
    }

    





    // Draw gun AFTER player sprite so it sits on top
    gun.display();


    // player coords
    textSize(16);
    fill(255);
    text(x, x, y+100);
    text(y, x+100, y+100);
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

        // Amount the player overlaps the platform horizontally
        float overlapLeft  = (p.x + p.w) - (x - w/2);
        float overlapRight = (x + w/2) - p.x;

        // Amount the player overlaps vertically
        float overlapTop    = (y + h/2) - p.y;
        float overlapBottom = (p.y + p.h) - (y - h/2);

        // Only resolve horizontal if the horizontal overlap is smaller
        if (min(overlapLeft, overlapRight) < min(overlapTop, overlapBottom)) {

          if (xVel > 0) {
            // moving right, hit platform on its left side
            x = p.x - w/2;
          } else if (xVel < 0) {
            // moving left, hit platform on right side
            x = p.x + p.w + w/2;
          }

          xVel = 0;
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
          
          if (yVel > SPLAT_VELOCITY) {
            println(yVel);
          splatted = true;
          
          } 
          
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
      //getUp = false;
    }
  }
}
