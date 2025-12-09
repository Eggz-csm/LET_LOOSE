class Carl {
  float x, y;
  float speed = 1.2;
  float orbitDistance = 200;
  float hp = 30;
  float shootCooldown = 300;
  float shootTimer = 300;
  float attackMode = 0;     // 0 = normal shots, 1 = spread shotsd
  float activationDistance = 400;   // how close player must be
  boolean active = false;
  float idleTime = 0;
  float idleAmplitude = 15;   // how far it floats
  float idleSpeed = 0.03;     // how fast it floats
  float startX, startY;       // original spawn position


 

  // Enemy flashing vars
  boolean flashing = false;
  int flashDuration = 150; // stays flashed for flashduration milis
  int flashEndTime = 0; // when does the flash stop

  //
  
  //PImage chompGif;
 
  SoundFile carlShoot1;
  SoundFile carlShoot2;
  SoundFile carlShoot3;
  SoundFile hit;
  SoundFile carlDie;
  
  Gif chompGif;

  Carl(PApplet app, float x, float y, SoundFile carlShoot1, SoundFile carlShoot2, SoundFile carlShoot3, SoundFile hit, SoundFile carlDie) {
    this.x = x;
    this.y = y;
    startX = x;
    startY = y;
    chompGif  = new Gif(app, "ShootySean.gif");
    chompGif.play();
    this.carlShoot1 = carlShoot1;
    this.carlShoot2 = carlShoot2;
    this.carlShoot3 = carlShoot3;
    this.hit = hit;
    this.carlDie = carlDie;
  }

  void update(Player p) {
    if (hp <= 0) {
      carlDie.play();
      return;
    }
    float d = dist(x, y, p.x, p.y);
    // --- Idle mode (enemy is dormant) ---
    if (!active) {
      if (d < activationDistance) {
        active = true;
      } else {
        idleFloat();    // << run idle motion
        return;
      }
    }
    // Check activation
    if (!active) {
      if (d < activationDistance) {
        active = true;  // wakes up
        
      } else {
        return;         // stays dormant
      }
    }

    // From here on, the enemy is active
    // ---------------------------------------------

    // Smooth follow/orbit logic
    float dx = p.x - x;
    float dy = p.y - y;
    float distToPlayer = dist(x, y, p.x, p.y);
    float angle = atan2(dy, dx);

    float targetX, targetY;

    if (distToPlayer > orbitDistance + 60) {
      targetX = x + cos(angle) * speed;
      targetY = y + sin(angle) * speed;
    } else if (distToPlayer < orbitDistance - 60) {
      targetX = x - cos(angle) * speed;
      targetY = y - sin(angle) * speed;
    } else {
      targetX = x + cos(angle + HALF_PI) * speed;
      targetY = y + sin(angle + HALF_PI) * speed;
    }

    x = lerp(x, targetX, 0.6);
    y = lerp(y, targetY, 0.6);
    
    // Shooting
    shootTimer--;
    if (shootTimer <= 0) {
      if (attackMode == 0) shootDirect(p);
      if (attackMode == 1) shootSpread(p);

      attackMode = int(random(2));
      shootTimer = shootCooldown;
    }
  }




  void shootDirect(Player p) {
    enemyBullets.add(new EnemyBullet(x, y, p.x, p.y));
    
    int r = int(random(2)); //chooses 0 or 1 randomly
    
    if (r==0) {
    carlShoot1.play();
    } else{
    carlShoot2.play();
    }
  }

  void shootSpread(Player p) {
    // Bullet spread stuffs woooooooo
    
      carlShoot3.play();
      
    float base = atan2(p.y - y, p.x - x);
    float spread = radians(25);

    float[] angles = { base - spread, base, base + spread };

    for (float a : angles) {
      enemyBullets.add(new EnemyBullet(x, y, x + cos(a), y + sin(a)));
    }
  }

  void damage(float dam) {
    hp -= dam;
    if (hp <= 0) {
      score += 1;    // add to global score
    }
    flash();
    hit.play();
  }

  void idleFloat() {
    idleTime += idleSpeed;

    // Horizontal bobbing
    x = startX + sin(idleTime) * idleAmplitude;

    // Vertical bobbing (optional)
    y = startY + cos(idleTime * 0.8) * (idleAmplitude * 0.7);
  }

  void display() {
    if (hp <= 0) return;

    pushStyle();

    if (flashing && millis() <flashEndTime) {

      tint(255, 100, 100); // red
    } else {
      flashing = false;
    }

    pushMatrix();
    translate(x, y);

    // Only face the player when active
    float ang = active ? atan2(p1.y - y, p1.x - x) : 0;

    rotate(ang);
    imageMode(CENTER);
    image(chompGif, 0, 0, 80, 80);

    popMatrix();
    popStyle();
  }


  void flash() {

    flashing = true;
    flashEndTime = millis() + flashDuration;
  }
}
