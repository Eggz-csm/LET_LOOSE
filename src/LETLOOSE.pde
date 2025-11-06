// Gabriel Farley, Ewan Carver, and Grace Perry | 11 Nov 2025 | LETLOOSE
Player p1;
LevelManage lvm;
ArrayList<Platform> platforms = new ArrayList<Platform>();

void setup() {
  size(500, 500);
  p1 = new Player();
  lvm = new LevelManage();
}

void draw() {
  lvm.display();

  for (Platform p : platforms) {
    p.display();
  }

  p1.update(platforms);
  p1.display();
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
