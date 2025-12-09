class stats { //All By Gabriel Farley //<>//
  PImage k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, oof, p;

  stats() {
    k0 = loadImage("K0.png");
    k1 = loadImage("K1.png");
    k2 = loadImage("K2.png");
    k3 = loadImage("K3.png");
    k4 = loadImage("K4.png");
    k5 = loadImage("K5.png");
    k6 = loadImage("K6.png");
    k7 = loadImage("K7.png");
    k8 = loadImage("K8.png");
    k9 = loadImage("K9.png");
    oof = loadImage("oof.png");
    p = loadImage("percent.png");
  }
  void kills() {
    String s = str(score);          // convert score to string

    int startX = 0;                 // top-left of number display
    int startY = 0;
    int spacing = 40;                // space between digits if needed
    int Vspacing = 5;
    if (score == 0) {
      image(oof, 0, 0);
      image(k0, 0, 0);
      return;
    }
    for (int i = 0; i < s.length(); i++) {
      char c = s.charAt(i);

      PImage digitImg = null;
      switch(c) {
      case '0':
        digitImg = k0;
        break;
      case '1':
        digitImg = k1;
        break;
      case '2':
        digitImg = k2;
        break;
      case '3':
        digitImg = k3;
        break;
      case '4':
        digitImg = k4;
        break;
      case '5':
        digitImg = k5;
        break;
      case '6':
        digitImg = k6;
        break;
      case '7':
        digitImg = k7;
        break;
      case '8':
        digitImg = k8;
        break;
      case '9':
        digitImg = k9;
        break;
      }

      if (digitImg != null) {
        image(digitImg, startX + i * (spacing), startY - i * (Vspacing));
      }
    }
  }
  void accu() {
    image(p, 0, -5);
    int ac;
    ac = 0;
    if (sf>0) {
      ac = int(round((sh * 100.0) / sf));
      if (ac>100) {
        ac=100;
      }
    }
    String a = str(ac);          // convert accuracy to string

    int startX = 85;                 // top-left of number display
    int startY = 60;
    int spacing = 40;                // space between digits if needed
    int Vspacing = 5;



    for (int i = 0; i < a.length(); i++) {
      char c = a.charAt(i);

      PImage digitImg = null;
      switch(c) {
      case '0':
        digitImg = k0;
        break;
      case '1':
        digitImg = k1;
        break;
      case '2':
        digitImg = k2;
        break;
      case '3':
        digitImg = k3;
        break;
      case '4':
        digitImg = k4;
        break;
      case '5':
        digitImg = k5;
        break;
      case '6':
        digitImg = k6;
        break;
      case '7':
        digitImg = k7;
        break;
      case '8':
        digitImg = k8;
        break;
      case '9':
        digitImg = k9;
        break;
      }
      if (digitImg != null) {
        image(digitImg, startX + i * (spacing), startY - i * (Vspacing));
      }
    }
    if (ac < 30) {
      image(oof, 0, 0);
      return;
    }
  }
  void hcombo() {
    String t = str(highCombo);          // convert h combo to string

    int startX = 85;                 // top-left of number display
    int startY = 140;
    int spacing = 45;                // space between digits if needed
    int Vspacing = 8;
    if (score == 0) {
      image(oof, 0, 0);
      image(k0, 85, 140);
      return;
    }
    for (int i = 0; i < t.length(); i++) {
      char c = t.charAt(i);

      PImage digitImg = null;
      switch(c) {
      case '0':
        digitImg = k0;
        break;
      case '1':
        digitImg = k1;
        break;
      case '2':
        digitImg = k2;
        break;
      case '3':
        digitImg = k3;
        break;
      case '4':
        digitImg = k4;
        break;
      case '5':
        digitImg = k5;
        break;
      case '6':
        digitImg = k6;
        break;
      case '7':
        digitImg = k7;
        break;
      case '8':
        digitImg = k8;
        break;
      case '9':
        digitImg = k9;
        break;
      }

      if (digitImg != null) {
        image(digitImg, startX + i * (spacing), startY - i * (Vspacing));
      }
    }
    if (highCombo < 3) {
      image(oof, 0, 0);
      return;
    }
  }
  void rate() {
    // Calculate accuracy
    int ac = 0;
    if (sf > 0) {
      ac = int(round((sh * 100.0) / sf));
      if (ac > 100) ac = 100;
    }

    // Normalize score components to 0-100
    float comboScore = min((highCombo / 20.0) * 100, 100); // Combo is 100% at 20
    float scoreScore = min(score * 20, 100);                     // 
    float accuracyScore = ac;                               // Already 0-100

    // Weighted average
    float finalScore = 0.3 * comboScore + 0.4 * scoreScore + 0.3 * accuracyScore;

    // Determine rating
    char ratingChar;
    if (finalScore >= 90) ratingChar = 'S';
    else if (finalScore >= 80) ratingChar = 'A';
    else if (finalScore >= 70) ratingChar = 'B';
    else if (finalScore >= 60) ratingChar = 'C';
    else if (finalScore >= 50) ratingChar = 'D';
    else ratingChar = 'F';

    // Draw rating
    PImage ratingImg = null;
    switch(ratingChar) {
    case 'S':
      ratingImg = loadImage("SR.png");
      break;
    case 'A':
      ratingImg = loadImage("AR.png");
      break;
    case 'B':
      ratingImg = loadImage("BR.png");
      break;
    case 'C':
      ratingImg = loadImage("CR.png");
      break;
    case 'D':
      ratingImg = loadImage("DR.png");
      break;
    case 'F':
      ratingImg = loadImage("FR.png");
      break;
    }

    if (ratingImg != null) {
      image(ratingImg, 0, 0); // Position of the rating
    }
  }
}
