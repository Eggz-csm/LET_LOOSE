// Gabriel Farley, Ewan Carver, and Grace Perry | 11 Nov 2025 | LETLOOSE
Player p1;
LevelManage lvm;
ArrayList<Platform> platforms = new ArrayList<Platform>();
float camX = 0;
float camY = 0;

void setup() {
  size(500, 500);
  p1 = new Player();
  lvm = new LevelManage();
}

void draw() {
  background(22);
  // Target camera position (centered on player)
  float targetCamX = width/2 - p1.x;
  float targetCamY = height/2 - p1.y; // or 0 if you only want horizontal scrolling

  // Smoothly interpolate (lerp) toward the target
  float lerpSpeed = 0.1; // smaller = smoother/slower camera
  camX = lerp(camX, targetCamX, lerpSpeed);
  camY = lerp(camY, targetCamY, lerpSpeed);

  // Apply camera transform
  pushMatrix();
  translate(camX, camY);

  // Draw world
  lvm.display();
  for (Platform p : platforms) {
    p.display();
  }

  p1.update(platforms);
  p1.display();

  popMatrix();
}

void mousePressed() {
}

void keyPressed() {
  if (key == 'a' || key == 'A') p1.moveLeft = true;
  if (keyCode == LEFT) p1.moveLeft = true;
  if (key == 'd'|| key == 'D') p1.moveRight = true;
  if (keyCode == RIGHT) p1.moveRight = true;
  if (key == ' ') p1.jump();
  if (keyCode == UP) p1.jump();
  if (key == 'w'|| key == 'W') p1.jump();
}

// When the key is released
void keyReleased() {
   if (key == 'a' || key == 'A') p1.moveLeft = false;
  if (keyCode == LEFT) p1.moveLeft = false;
  if (key == 'd'|| key == 'D') p1.moveRight = false;
  if (keyCode == RIGHT) p1.moveRight = false;
}
