class levOne {
  levOne() {
    p1.x = 0;
    p1.y = 0;
    // Static platforms
    platforms.add(new Platform(0, 0, 900, 20, color(150, 200, 255))); //blue
    platforms.add(new Platform(900, -80, 200, 100, color(255, 100, 100))); //red
    platforms.add(new Platform(1100, -400, 100, 420, color(150, 100, 100))); //purple
    platforms.add(new Platform(800, -200, 100, 20, color(255, 100, 100))); //red
    platforms.add(new Platform(1000, -300, 100, 20, color(100, 255, 100))); //green
    platforms.add(new Platform(1200, -400, 900, 100, color(100, 255, 255))); //cyan
    platforms.add(new Platform(700, -600, 900, 100, color(255, 100, 255))); //purp
    platforms.add(new Platform(1600, -520, 100, 20, color(255, 255, 100))); //yellow
    platforms.add(new Platform(300, -700, 300, 100, color(255, 100, 100))); //red
    platforms.add(new Platform(200, -1000, 100, 800, color(255, 100, 100))); //red
    
    
    
    
    
    
/*
    // Horizontal moving platform
    platforms.add(new Platform(260, -250, 100, 20, color(100, 255, 100),
      2, 0, 260, 400, 250, 250)); // moves left-right

    // Vertical moving platform
    platforms.add(new Platform(50, -200, 80, 20, color(255, 255, 100),
      0, 2, 50, 50, -200, 300)); // moves up-down
      
      */
  }

  void display() {
  }
}
  
  
  
  
  
  
  
  
  
