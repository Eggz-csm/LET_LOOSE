// -------------------------------------------
// BUTTON CLASS
// -------------------------------------------
class Button {
  String label;
  float x, y, w, h;
  PImage button;

  Button(String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    if (label.equals("Start")) {

      button = loadImage("StartButton.png");
    } else if (label.equals("Settings")) {

      button = loadImage("SettingsButton.png");
    }
  }

  void display() {
    imageMode(CENTER);
    image(button, x, y, w, h);
    // fill(255);
    //stroke(0);
    //rect(x, y, w, h, 10);
    //fill(0);
    //textAlign(CENTER, CENTER);
    //textSize(16);
    //text(label, x + w/2, y + h/2);
  }

  boolean clicked() {
    return (mouseX > x-w/2 && mouseX < x+w/2 && mouseY > y-h/2 && mouseY < y+h/2 && mousePressed);
  }
}
