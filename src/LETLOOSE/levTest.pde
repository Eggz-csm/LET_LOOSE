class levTest {
  levTest() {
    // Static platforms
    platforms.add(new Platform(0, height - 20, width, 20, color(150, 200, 255)));
    platforms.add(new Platform(100, 350, 120, 20, color(255, 100, 100)));

    // Horizontal moving platform
    platforms.add(new Platform(260, 250, 100, 20, color(100, 255, 100),
                               2, 0, 260, 400, 250, 250)); // moves left-right

    // Vertical moving platform
    platforms.add(new Platform(50, 200, 80, 20, color(255, 255, 100),
                               0, 2, 50, 50, 100, 300)); // moves up-down
  }

  void display() { }
}
