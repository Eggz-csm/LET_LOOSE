// Gabriel Farley, Ewan Carver, and Grace Perry | 8 Dec 2025 | LETLOOSE
//----------------------------------------------------------------------
//GLOBALS
//-------------------------------------------------------

import gifAnimation.*;
import processing.sound.*;


char screen = 's';   // s = start, t = settings, p = play, u = pause, g = game over, a = app stats
Button btnStart, btnPause, btnSettings, btnBack;
//score(score stuff by Grace)
int score = 0;
int playerHP = 100;
int lastScoreTime = 0;
boolean anyCarlsActive = false;

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
MusicManage music;
//Carl carl1; //TODO: clean this up

ArrayList<Platform> platforms = new ArrayList<Platform>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Carl> carls = new ArrayList<Carl>();
ArrayList<EnemyBullet> enemyBullets = new ArrayList<EnemyBullet>();

PImage title;
PImage level1Img; //collision img
PImage level1vis; // actual render
PImage level1bg; //shade version
float level1X = -400;       // left boundary of level
float level1Y = -3200;      // top boundary of level
float level1W = 2700;       // width of level in world coords
float level1H = 3200;       // height of level in world coords


// Camera floats and controls
float camX = 0;
float camY = 0;
float zoom = 1.0;         // actual zoom used for drawing
float targetZoom = 1.0;   // where we want the zoom to go

//-------------------------------------------------------

void setup() {
  pixelDensity(1);
  noSmooth();
  size(1200, 800);
  
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
  
  music = new MusicManage(tense, calm);
  p1 = new Player(this, splat);
  lvm = new LevelManage(this);
  btnStart    = new Button("Start", 640/2+10, height/2+100, 640, 240);
  btnSettings    = new Button("Settings", 560/2+10, height/2+260, 560, 200);
  title = loadImage("LetLooseTitle.png");
  screen = 's';
  lastScoreTime = millis();
  level1Img = loadImage("levonecol.png");
  level1vis = loadImage("levonevisual.png");
  level1bg = loadImage("levonebgshade.png");
}

//-------------------------------------------------------

void draw() {
  background(34,44,37);
  // SCREEN MANAGE
  switch(screen) {


  case 's': // start screen - Ewan Carver
    btnStart.display();
    btnSettings.display();
    if (btnStart.clicked()) {

      screen = 'p';
    } else if (btnSettings.clicked()) {

      screen = 't';
    }
    drawStart();
    break;
  case 't':
    background(20);
    drawSettings();
    break;

  case 'u':
    background(20);
    btnStart.display();
    if (btnStart.clicked()) {
      screen = 'p';
    }
    drawPause();
    break;
  case 'g':


    drawGameOver();
    break;
  case 'a':

    drawStats();
    break;
  case 'p':
    play();
    drawHUD();
    break;
  }
}

void play() {

  
  
  music.startMusic();
  music.playMusic(); // runs ongoing music code

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

      if (playerHP <= 0) screen = 'g';
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

  //drawMask();

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

  textAlign(RIGHT);
  text("Score: " + score, width - 20, 40);
  
  rectMode(CENTER);
  fill(255,178,178);
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
  text("PAUSE SCREEN (WIP!!!)", width/2, 50);
  // btnPause.display();
}
// Grace
void drawSettings() {
  background(200, 150, 120);
  textSize(32);
  fill(255);
  text("SETTINGS (WIP!!!)", width/2, 50);
  btnSettings.display();
}
// Gabriel
void drawGameOver() {
  background(0);
  textSize(32);
  fill(255);
  text("GAME OVER", width/2, 50);
  //btnRetry.display();
}
// Ewan
void drawStats() {
  background(0);
  textSize(32);
  fill(0, 255, 0);
  text("STATS (WIP!!!)", width/2, 50);
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
