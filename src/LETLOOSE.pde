// Gabriel Farley, Ewan Carver, and Grace Perry | 11 Nov 2025 | LETLOOSE
Player p1;
LevelManage lvm;

void setup() {
  size(500,500);
  p1 = new Player();
  lvm = new LevelManage();
}

void draw() {
  lvm.display();
  if (p1.moveLeft) {
    p1.x -= 5;
  }
  if (p1.moveRight) {
    p1.x += 5;
  }
  p1.display();
  p1.move(p1.x,p1.y);
}

void mousePressed() {
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    p1.moveLeft = true;
  }
  if (key == 'd' || key == 'D') {
    p1.moveRight = true;
  }
}

// When the key is released
void keyReleased() {
  if (key == 'a' || key == 'A') {
    p1.moveLeft = false;
  }
  if (key == 'd' || key == 'D') {
    p1.moveRight = false;
  }
}

