// Gabriel Farley, Ewan Carver, and Grace Perry | 11 Nov 2025 | LETLOOSE
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

void setup() {
  size(500, 500);
  p1 = new Player(this);
  lvm = new LevelManage();
}

void draw() {
  background(22);

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

void mousePressed() {
  // Fire a bullet from the gun when mouse pressed.
  // Convert mouse to world coords again (mouseX,mouseY are screen coords)
  float worldMouseX = (mouseX / zoom) - camX;
  float worldMouseY = (mouseY / zoom) - camY;
  p1.gun.fire(worldMouseX, worldMouseY, bullets);
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
}

// When the key is released
void keyReleased() {
  if (key == 'a' || key == 'A') p1.moveLeft = false;
  if (keyCode == LEFT) p1.moveLeft = false;
  if (key == 'd'|| key == 'D') p1.moveRight = false;
  if (keyCode == RIGHT) p1.moveRight = false;
}
