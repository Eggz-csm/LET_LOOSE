Level lev;
boolean moveLeft = false;
boolean moveRight = false;

void setup() {
  size(500, 500);
  lev = new Level(250, 250);
}

void draw() {
  background(0);

  // Handle continuous movement
  if (moveLeft) {
    lev.x -= 5;
  }
  if (moveRight) {
    lev.x += 5;
  }

  lev.display();
}

// When a key is pressed down
void keyPressed() {
  if (key == 'a' || key == 'A') {
    moveLeft = true;
  }
  if (key == 'd' || key == 'D') {
    moveRight = true;
  }
}

// When the key is released
void keyReleased() {
  if (key == 'a' || key == 'A') {
    moveLeft = false;
  }
  if (key == 'd' || key == 'D') {
    moveRight = false;
  }
}
