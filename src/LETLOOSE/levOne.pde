class levOne {

  Carl carl1, carl2, carl3, carl4, carl5;


  //final color COLOR_RED = color(255, 100, 100);
  final color COLOR_Movingp = color(64, 76, 65);


  levOne(PApplet app) {
    p1.x = -208;
    p1.y = -49;
    //enemies
    carl1 = new Carl(app, 300, -100, carlShoot1, carlShoot2, carlShoot3, hit);
    carls.add(carl1);
    carl2 = new Carl(app, 1700, -700, carlShoot1, carlShoot2, carlShoot3, hit);
    carls.add(carl2);
    carl3 = new Carl(app, 740, -960, carlShoot1, carlShoot2, carlShoot3, hit);
    carls.add(carl3);
    carl4 = new Carl(app, 820, -2890, carlShoot1, carlShoot2, carlShoot3, hit);
    carls.add(carl4);
    carl5 = new Carl(app, 1000, -2000, carlShoot1, carlShoot2, carlShoot3, hit);
    carls.add(carl5);
    // Static platformsdd
    //platforms.add(new Platform(-400, -380, 100, 4w color(150, 200, 255))); //l blue
    //platforms.add(new Platform(-300, -1800, 600, 1600, color(255, 150, 100))); //orange up
    //platforms.add(new Platform(900, -80, 200, 100, COLOR_RED));
    //platforms.add(new Platform(1100, -300, 100, 320, color(150, 100, 100))); //brun
    //platforms.add(new Platform(800, -200, 100, 20, color(255, 100, 100))); //red
    //platforms.add(new Platform(1000, -300, 100, 20, color(100, 255, 100))); //green
    //platforms.add(new Platform(1100, -400, 1000, 100, color(100, 255, 255))); //cyan across
    //platforms.add(new Platform(2100, -1050, 300, 750, color(100, 255, 255))); //cyan up
    //platforms.add(new Platform(700, -600, 900, 100, color(255, 100, 255))); //pink
    //platforms.add(new Platform(1600, -520, 100, 20, color(255, 255, 100))); //yellow
    //platforms.add(new Platform(300, -700, 300, 100, color(255, 100, 100))); //red
    //platforms.add(new Platform(300, -800, 100, 100, color(255, 100, 100))); //red box
    //platforms.add(new Platform(750, -900, 250, 100, color(100, 100, 255))); //blue

    platforms.add(new Platform(470, -870, 100, 20, COLOR_Movingp,
      2, 0, 460, 690, -850, -850)); //used to be green (100, 255, 100) moving

    //platforms.add(new Platform(1100, -1000, 200, 100, color(100, 255, 100))); //green
    //platforms.add(new Platform(1400, -1100, 200, 100, color(255, 100, 100))); //red
    //platforms.add(new Platform(1700, -1200, 600, 150, color(200, 100, 200))); //purple across
    //platforms.add(new Platform(2300, -1700, 100, 650, color(200, 100, 200))); //purple up
    //platforms.add(new Platform(2150, -1350, 150, 150, color(250, 250, 100))); //yellow
    //platforms.add(new Platform(2050, -1300, 100, 100, color(100, 250, 250))); //cyan

    platforms.add(new Platform(1600, -1450, 100, 20, COLOR_Movingp,
      2, 0, 1500, 2000, -1450, -1450)); // used to be color(100, 100, 255) blue moving

    //platforms.add(new Platform(900, -1500, 600, 200, color(255, 100, 100))); //red
    //platforms.add(new Platform(500, -1600, 300, 50, color(255, 255, 100))); //yellow
    //platforms.add(new Platform(300, -3200, 200, 2000, color(255, 100, 255))); //pink up
    //platforms.add(new Platform(1000, -1900, 1400, 200, color(150, 100, 100))); //brun
    //platforms.add(new Platform(900, -1800, 100, 100, color(100, 100, 150))); //navy
    //platforms.add(new Platform(700, -1720, 100, 20, color(255, 255, 100))); //yellow
    //platforms.add(new Platform(1500, -2100, 300, 100, color(100, 150, 100))); //d green
    //platforms.add(new Platform(1900, -2000, 100, 100, color(100, 255, 100))); //green
    //platforms.add(new Platform(2000, -2200, 100, 300, color(100, 100, 255))); //blue
    //platforms.add(new Platform(2100, -3200, 100, 1300, color(100, 100, 255))); //blue
    //platforms.add(new Platform(1900, -2200, 200, 50, color(100, 255, 255))); //cyan

    platforms.add(new Platform(1800, -2550, 100, 20, COLOR_Movingp,
      0, 2, 1800, 1800, -2750, -2270)); //used to be color(255, 255, 100)yellow moving vert

    //platforms.add(new Platform(1300, -2600, 400, 100, COLOR_RED)); //red
    //platforms.add(new Platform(1000, -2700, 200, 400, COLOR_RED)); //red
    //platforms.add(new Platform(500, -2700, 350, 200, COLOR_RED)); //red


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
    carl1.update(p1);
    carl1.display();
  }
}
