class levOne {
  
  
  final color COLOR_RED = color(255, 100, 100);
    
  
  
  levOne() {
    p1.x = 2000;
    p1.y = -1225;
    // Static platforms
    platforms.add(new Platform(-200, 0, 1100, 20, color(150, 200, 255))); //l blue
     platforms.add(new Platform(-300, -1800, 600, 1600, color(255, 150, 100))); //orange up
    platforms.add(new Platform(900, -80, 200, 100, COLOR_RED)); 
    platforms.add(new Platform(1100, -300, 100, 320, color(150, 100, 100))); //brun
    platforms.add(new Platform(800, -200, 100, 20, color(255, 100, 100))); //red
    platforms.add(new Platform(1000, -300, 100, 20, color(100, 255, 100))); //green
    platforms.add(new Platform(1100, -400, 1000, 100, color(100, 255, 255))); //cyan across
    platforms.add(new Platform(2100, -1050, 300, 750, color(100, 255, 255))); //cyan up
    platforms.add(new Platform(700, -600, 900, 100, color(255, 100, 255))); //pink
    platforms.add(new Platform(1600, -520, 100, 20, color(255, 255, 100))); //yellow
    platforms.add(new Platform(300, -700, 300, 100, color(255, 100, 100))); //red
    platforms.add(new Platform(300, -800, 100, 100, color(255, 100, 100))); //red box
    platforms.add(new Platform(750, -900, 250, 100, color(100, 100, 255))); //blue
   
    platforms.add(new Platform(450, -870, 100, 20, color(100, 255, 100),
    2, 0, 450, 750, -850, -850)); //green moving
    
    platforms.add(new Platform(1100, -1000, 200, 100, color(100, 255, 100))); //green
    platforms.add(new Platform(1400, -1100, 200, 100, color(255, 100, 100))); //red
    platforms.add(new Platform(1700, -1200, 600, 150, color(200, 100, 200))); //purple across
    platforms.add(new Platform(2300, -1650, 100, 600, color(200, 100, 200))); //purple up
    platforms.add(new Platform(2150, -1350, 150, 150, color(250, 250, 100))); //yellow
    platforms.add(new Platform(2050, -1300, 100, 100, color(100, 250, 250))); //cyan
    
    platforms.add(new Platform(1600, -1450, 100, 20, color(100, 100, 255),
    2, 0, 1600, 2150, -1450, -1450)); //blue moving
    
    platforms.add(new Platform(900, -1500, 600, 200, color(255, 100, 100))); //red
    platforms.add(new Platform(500, -1600, 300, 50, color(255, 255, 100))); //yellow
    platforms.add(new Platform(300, -1800, 200, 600, color(255, 100, 255))); //pink
    
    
    
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
  
  
  
  
  
  
  
  
  
