// Gabriel Farley, Ewan Carver, and Grace Perry | 11 Nov 2025 | LETLOOSE
//----------------------------------------------------------------------
//GLOBALS
//-------------------------------------------------------

char screen = 's';   // s = start, t = settings, p = play, u = pause, g = game over, a = app stats
Button btnStart, btnMenu, btnSettings, btnBack;

import gifAnimation.*;
Player p1;
LevelManage lvm;
ArrayList<Platform> platforms = new ArrayList<Platform>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

// Camera floats and controls
float camX = 0;
float camY = 0;
float zoom = 1.0;         // actual zoom used for drawing
float targetZoom = 1.0;   // where we want the zoom to go

//-------------------------------------------------------

void setup() {
  size(500, 500);
  p1 = new Player(this);
  lvm = new LevelManage();
  btnStart    = new Button("Start", width/2, width/2, width/2, height/2);
  screen = 's';
  
}

//-------------------------------------------------------

void draw() {
  background(22);
  // SCREEN MANAGE
  switch(screen) {
    
    
  case 's': // start screen - Ewan Carver
    background(20);
    btnStart.display();
    if (btnStart.clicked()) {
    screen = 'p';
    }
    drawStart();
    break;
  case 't':
     background(20);
    btnStart.display();
    if (btnStart.clicked()) {
    screen = 'p';
    }
    drawStart();
    break;
  
  case 'u':
     background(20);
    btnStart.display();
    if (btnStart.clicked()) {
    screen = 'p';
    }
    drawStart();
    break;
  case 'g':
     background(20);
    btnStart.display();
    if (btnStart.clicked()) {
    screen = 'p';
    }
    drawStart();
    break;
  case 'a':
     background(20);
    btnStart.display();
    if (btnStart.clicked()) {
    screen = 'p';
    }
    drawStart();
    break;
  case 'p':  
  play();
    break;
  }

}

void play() {
    

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

  popMatrix();
  }
void drawStart() {
  background(100, 160, 200);
  textAlign(CENTER);
  textSize(32);
  text("START SCREEN", width/2, 50);
  btnStart.display();
}

void drawMenu() {
  background(120, 200, 140);
  textSize(32);
  text("MENU SCREEN", width/2, 50);
  btnMenu.display();
}

void drawSettings() {
  background(200, 150, 120);
  textSize(32);
  text("SETTINGS", width/2, 50);
  btnSettings.display();
}

void mousePressed() {
  // Fire a bullet from the gun when mouse pressed.
  // Convert mouse to world coords again (mouseX,mouseY are screen coords)
 // Only shoot in play mode
  if (screen == 'p') {
    float worldMouseX = (mouseX / zoom) - camX;
    float worldMouseY = (mouseY / zoom) - camY;
    p1.gun.fire(worldMouseX, worldMouseY, bullets);
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') p1.moveLeft = true;
  if (keyCode == LEFT) p1.moveLeft = true;
  if (key == 'd'|| key == 'D') p1.moveRight = true;
  if (keyCode == RIGHT) p1.moveRight = true;
  if (key == ' ') p1.jump();
  if (keyCode == UP) p1.jump();
  if (key == 'w'|| key == 'W') p1.jump();
  if (key == '+') targetZoom *= 1.1; // zoom in w/camera
  if (key == '-') targetZoom /= 1.1; // zoom out
  
  
  if (key == '1') screen = 's';
  if (key == '2') screen = 't';
  if (key == '3') screen = 'p';
  if (key == '4') screen = 'u';
  if (key == '5') screen = 'g';
  if (key == '6') screen = 'a';
  
}

// When the key is released
void keyReleased() {
  if (key == 'a' || key == 'A') p1.moveLeft = false;
  if (keyCode == LEFT) p1.moveLeft = false;
  if (key == 'd'|| key == 'D') p1.moveRight = false;
  if (keyCode == RIGHT) p1.moveRight = false;
}
