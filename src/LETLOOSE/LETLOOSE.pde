// Gabriel Farley, Ewan Carver, and Grace Perry | 7 Dec 2025 | LETLOOSE
//----------------------------------------------------------------------
// Gabe - Coding player physics, stats, pixel collision, camera, and enemy ai
// Ewan - Input sound design, adaptive music, animations and art, as well as organizing code
// Grace - Start screen, setup screen system, made original concept level, did art for screens
//GLOBALS 
//-------------------------------------------------------

import gifAnimation.*;
import processing.sound.*;


char screen = 's';   // s = start, t = settings, p = play, u = pause, g = game over, a = app stats
Button btnStart, btnPause, btnSettings, btnBack;

int score = 0;
int combo, lastComboHitTime, comboDecayDelay, highCombo;
int playerHP = 100;
boolean anyCarlsActive = false;

int deathStartTime = 0;

SoundFile tense;
SoundFile calm;
SoundFile carlShoot1;
SoundFile carlShoot2;
SoundFile carlShoot3;
SoundFile shoot;
SoundFile splat;
SoundFile hit;
SoundFile carlDie;


Player p1;
LevelManage lvm;
stats stats;
MusicManage music;

ArrayList<Platform> platforms = new ArrayList<Platform>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Carl> carls = new ArrayList<Carl>();
ArrayList<EnemyBullet> enemyBullets = new ArrayList<EnemyBullet>();

PImage god;
PImage title;
PImage GO;
Gif select; // selection gif
PImage level1Img; //collision img
PImage level1vis; // actual render
PImage level1bg; //shade version
float level1X = -400;       // left boundary of    level
float level1Y = -3200;      // top boundary of level
float level1W = 2700;       // width of level in world coords
float level1H = 3200;       // height of level in world coords
float sh, sf, ac; //shotshit, shotsfired, and accuracy made from the two

// Camera floats and controls
float camX = 0;
float camY = 0;
float zoom = 1.0;         // actual zoom used for drawing
float targetZoom = 1.0;   // where we want the zoom to go

boolean bloodActive = false;
float bloodTimer = 0;
ArrayList<PVector> bloodPoints= new ArrayList<PVector>();

boolean died;
boolean debugMousecoord;
boolean anyCarlsActiveThisFrame;
//-------------------------------------------------------

void setup() {
  pixelDensity(1);
  noSmooth();
  size(1200, 800);
  debugMousecoord = false;
  died = false;
  restart();
}

//-------------------------------------------------------

void draw() {
  background(34, 44, 37);
  god.resize(1200, 800);
  // SCREEN MANAGE
  switch(screen) {


  case 's': // start screen - Ewan Carver
    btnStart.display();
    //btnSettings.display();
    if (btnStart.clicked()) {

      screen = 'p';
      //} else if (btnSettings.clicked()) {

      //  screen = 't';
    }
    drawStart();
    break;
  case 'd':      // NEW DYING STATE
    drawDying();
    break;
  //case 't':
  //  background(20);
  //  drawSettings();
  //  break;

  case 'u':
    background(20);
    btnStart.display();
    if (btnStart.clicked()) {
      screen = 'p';
    }
    drawPause();
    break;
  case 'g':
    if (music != null) {
      music.stopMusic(); // stop music immediately
    }
    drawEnd();
    break;
  case 'a':

    drawStats();
    break;
  case 'p':
    play();
    drawHUD();
    break;
  }
  // DEBUG: Onscreen mouse coords
  if (debugMousecoord) {
    fill(255);
    textSize(24);
    textAlign(LEFT);
    text("X:" + mouseX + "  "+ "Y:" + mouseY, 20, 40);
  }
}

void play() {

  died = true;

  // Only start music once when entering play mode
  if (!music.started) {
    music.startMusic();
  }

  // Always update volumes (for fade switching)
  music.playMusic();

  if (playerHP >= 0) screen = 'g';

  // Smoothly interpolate zoom (like camera position)
  float zoomLerpSpeed = 0.1; // smaller = slower/smoother
  zoom = lerp(zoom, targetZoom, zoomLerpSpeed);

  // Target camera position (centered on player)
  float targetCamX = width/(2*zoom) - p1.x;
  float targetCamY = height/(2*zoom) - p1.y; // or 0 if you only want horizontal scrolling

  // Smoothly interpolate (lerp) toward the target
  float lerpSpeed = 0.1; // smaller = smoother/slower camera
  camX = lerp(camX, targetCamX, lerpSpeed);
  camY = lerp(camY, targetCamY, lerpSpeed);

  // Convert mouse position from screen coords to world coords (important)
  float worldMouseX = (mouseX / zoom) - camX;
  float worldMouseY = (mouseY / zoom) - camY;

  // Apply camera transform for drawing world
  pushMatrix();
  scale(zoom);
  translate(camX, camY);

  // Draw world
  lvm.display();
  for (Platform p : platforms) {
    p.display();
    p.update();
  }

  boolean anyCarlsActiveThisFrame = false;
  // --- Update all Carls ---
  for (int i = carls.size()-1; i >= 0; i--) {
    Carl c = carls.get(i);
    c.update(p1);
    c.display();

    if (c.active) anyCarlsActiveThisFrame = true;
    if (c.hp <= 0) carls.remove(i);
  }

  if (anyCarlsActiveThisFrame != anyCarlsActive) {
    anyCarlsActive = anyCarlsActiveThisFrame;

    music.switchMusic();
  }

  //Update enbullets
  for (int i = enemyBullets.size()-1; i >= 0; i--) {
    EnemyBullet eb = enemyBullets.get(i);
    eb.update();
    eb.display();

    if (dist(eb.x, eb.y, p1.x, p1.y) < 30) {
      playerHP -= 10;
      eb.dead = true;
      p1.flash();

      // >>> RESET COMBO <<<
      combo = 0;
      if (playerHP <= 0) {
        triggerBloodSplatter();
        deathStartTime = millis();  // begin 1-second freeze
        screen = 'd';               // go to dying state
        popMatrix();                // IMPORTANT: close matrix before leaving play()
        return;                     // stop updating this frame
      }
    }

    if (eb.dead) enemyBullets.remove(i);
  }
  // Update player (physics)
  p1.update(platforms);

  // Update gun aiming (provide world mouse)
  p1.gun.update(worldMouseX, worldMouseY);

  // Update bullets (they are in world space)
  for (int i = bullets.size()-1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();
    if (b.dead) bullets.remove(i);
  }
  // Draw player + gun
  p1.display();

  // --- COMBO DECAY WITH INCREASING SPEED ---
  if (combo > 0) {
    // decay speed increases with combo but never below 0.5 seconds
    float decayInterval = max(500, 5000 - combo * 300);
    // 5000ms base, minus 0.3s per combo

    if (millis() - lastComboHitTime >= decayInterval) {
      combo--; // decrease combo
      lastComboHitTime = millis(); // reset combo timer oh yaaaaa
    }
  }



  popMatrix();



  // movement fix for not moving when getting up
  if (p1.gettingUp) {
    p1.moveLeft = false;
    p1.moveRight = false;
  }
}
void drawHUD() {
  fill(255);
  textSize(24);
  textAlign(LEFT);
  text("HP: " + playerHP, 20, 40);
  textAlign(LEFT);
  text("Combo: " + combo, 20, 70);
  textAlign(RIGHT);
  text("Score: " + score, width - 20, 40);

  rectMode(CENTER);
  fill(255, 178, 178);
  rect(width/2, height-50, 200, 20);
  fill(208, 82, 82);
  rect(width/2+playerHP-100, height-50, playerHP*2, 20);
}

void drawStart() {
  background(31, 0, 0);
  textAlign(CENTER);
  // textSize(32);
  //text("START SCREEN", width/2, 50);
  imageMode(CENTER);
  image(title, width/2, 800/2);
  btnStart.display();
  btnSettings.display();
}

void drawPause() {
  background(120, 200, 140);
  textSize(32);
  fill(255);
  text("PAUSE SCREEN", width/2, 50);
  // btnPause.display();
}
//// Grace
//void drawSettings() {
//  background(200, 150, 120);
//  textSize(32);
//  fill(255);
//  text("SETTINGS", width/2, 50);
//  btnSettings.display();
//}
// Gabriel
void drawEnd() {
  imageMode(CORNER);
  if (bloodActive) drawBloodSplatter();
  if (select == null) {
    select = new Gif(this, "select.gif");
    select.play();
  }
  image(GO, 0, 0);
  stats.kills();
  stats.accu();
  stats.hcombo();
  stats.rate();
  if (mouseX > 50 && mouseX < 500 && mouseY > 315 && mouseY < 500) {
    image(select, 0, 0);
    if (mouseX > 50 && mouseX < 500 && mouseY > 315 && mouseY < 500 && mousePressed) {
      restart();
    }
  } else {
    if (mouseX > 100 && mouseX < 470 && mouseY > 510 && mouseY < 740) {
      image(select, 45, 250);
      if (mouseX > 100 && mouseX < 470 && mouseY > 510 && mouseY < 740 && mousePressed) {
        exit();
      }
    } else {
      return;
    }
  }
}
// Ewan
void drawStats() {
  background(0);
  textSize(32);
  fill(0, 255, 0);
  text("GET READY TO GET STATISTICAL", width/2, 50);
  //btnRetry.display();
}
boolean isSolidPixel(float wx, float wy) {

  // world → image
  float fx = map(wx, level1X, level1X + level1W, 0, level1Img.width  - 1);
  float fy = map(wy, level1Y, level1Y + level1H, 0, level1Img.height - 1);

  int ix = constrain(int(fx), 0, level1Img.width  - 1);
  int iy = constrain(int(fy), 0, level1Img.height - 1);

  int c = level1Img.get(ix, iy);
  return alpha(c) > 20;
}


void mousePressed() {
  // Fire a bullet from the gun when mouse pressed.
  // Convert mouse to world coords again (mouseX,mouseY are screen coords)
  // Only shoot in play mode
  if (screen == 'p') {

    shoot.play();

    float worldMouseX = (mouseX / zoom) - camX;
    float worldMouseY = (mouseY / zoom) - camY;
    p1.gun.fire(worldMouseX, worldMouseY, bullets);
  }
}

void keyPressed() {
  // Movement
  if (p1.gettingUp == false) {
    if (key == 'a' || key == 'A') p1.moveLeft = true;
    if (keyCode == LEFT) p1.moveLeft = true;
    if (key == 'd'|| key == 'D') p1.moveRight = true;
    if (keyCode == RIGHT) p1.moveRight = true;
    if (key == ' ') p1.jump();
    if (keyCode == UP) p1.jump();
    if (key == 'w'|| key == 'W') p1.jump();
  } else {
    if (key == 'a' || key == 'A') p1.moveLeft = false;
    if (keyCode == LEFT) p1.moveLeft = false;
    if (key == 'd'|| key == 'D') p1.moveRight = false;
    if (keyCode == RIGHT) p1.moveRight = false;
  }

  if (key == '+') targetZoom *= 1.1; // zoom in w/camera
  if (key == '=') targetZoom *= 1.1; // zoom in w/camera
  if (key == '-') targetZoom /= 1.1; // zoom out


  if (key == '1') screen = 's';
  if (key == '2') screen = 't';
  if (key == '3') screen = 'p';
  if (key == '4') screen = 'u';
  if (key == '5') screen = 'g';
  if (key == '6') screen = 'a';

  if (key == '0') p1.toggleDebug();

  if (key == 'p') music.switchMusic();
}

// When the key is released
void keyReleased() {
  if (key == 'a' || key == 'A') p1.moveLeft = false;
  if (keyCode == LEFT) p1.moveLeft = false;
  if (key == 'd'|| key == 'D') p1.moveRight = false;
  if (keyCode == RIGHT) p1.moveRight = false;
}

void restart() {

  // --- Stop existing music ---
  if (music != null) {
    music.stopMusic();
  }

  // --- Reset global game stats ---
  score = 0;
  playerHP = 100;

  // --- Reset camera + zoom ---
  camX = 0;
  camY = 0;
  zoom = 1.0;
  targetZoom = 1.0;

  // --- Clear all world objects ---
  platforms.clear();
  bullets.clear();
  enemyBullets.clear();
  carls.clear();

  // --- Reload sound files ---
  tense = new SoundFile(this, "facility_tense.wav");
  calm  = new SoundFile(this, "facility_calm.wav");
  shoot = new SoundFile(this, "GunFire.wav");
  shoot.amp(0.0);
  splat = new SoundFile(this, "Thump.wav");
  hit = new SoundFile(this, "Hit.wav");
  carlDie = new SoundFile(this, "CarlDie.wav");
  carlShoot1 = new SoundFile(this, "EnemyShoot1.wav");
  carlShoot2 = new SoundFile(this, "EnemyShoot2.wav");
  carlShoot3 = new SoundFile(this, "EnemyShoot3.wav");

  // --- Create or reuse MusicManage ---
  if (music == null) {
    music = new MusicManage(tense, calm);
  } else {
    music.tense = tense;
    music.calm = calm;
    music.started = false;
    music.switching = false;
  }

  // --- Reload images ---
  god = loadImage("GameOverDeath.jpeg");
  title = loadImage("LetLooseTitle.png");
  GO = loadImage("GOS.png");
  level1Img = loadImage("levonecol.png");
  level1vis = loadImage("levonevisual.png");
  level1bg = loadImage("levonebgshade.png");

  // --- Recreate player ---
  p1 = new Player(this, splat);

  // --- Recreate level manager ---
  lvm = new LevelManage(this);

  // --- Recreate stats ---
  stats = new stats();
  sh = 0;
  sf = 0;

  highCombo = 0;
  combo = 0;
  lastComboHitTime = 0;
  comboDecayDelay = 5000;

  // --- Recreate menu buttons ---
  btnStart    = new Button("Start", 640/2+10, height/2+100, 640, 240);
  btnSettings = new Button("Settings", 560/2+10, height/2+260, 560, 200);

  if (died) {
    screen = 'p';
  }
}
void triggerBloodSplatter() {
  bloodActive = true;
  bloodTimer = 0;
  bloodPoints.clear();

  // Make ~120 droplets
  for (int i = 0; i < 120; i++) {

    // Each blood droplet has:
    // - screen position (random around center)
    // - size
    // - a little motion offset

    float angle = random(TWO_PI);
    float dist = random(20, 700);

    float x = width/2 + cos(angle) * dist;
    float y = height/2 + sin(angle) * dist;

    bloodPoints.add(new PVector(x, y));
  }
}
void drawBloodSplatter() {

  bloodTimer += 0.02;

  // Opacity fades out
  float alpha = map(bloodTimer, 0, 1.0, 255, 0);
  alpha = constrain(alpha, 0, 255);

  noStroke();
  fill(180, 0, 0, alpha); // dark-red blood

  // Draw all splatter points
  for (PVector p : bloodPoints) {
    float size = random(80, 160);
    ellipse(p.x, p.y, size, size);
  }

  // After 1 second, turn it off
  if (bloodTimer >= 1.0) {
    bloodActive = false;
  }
}

void drawDying() {

  // Draw frozen scene from last frame
  playFrozenFrame();

  // Draw blood splatter on top
  if (bloodActive) drawBloodSplatter();

  // After 1 second → go to Game Over
  if (millis() - deathStartTime >= 1000) {
    screen = 'g';
  }
}

void playFrozenFrame() {

  pushMatrix();
  scale(zoom);
  translate(camX, camY);

  // Draw level and all objects exactly as they last were
  lvm.display();

  for (Platform p : platforms)        p.display();
  for (Carl c : carls)                c.display();
  for (EnemyBullet eb : enemyBullets) eb.display();
  for (Bullet b : bullets)            b.display();

  p1.display();

  popMatrix();
}

