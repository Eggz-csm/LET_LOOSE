class MusicManage { // All by Ewan Carver

  SoundFile tense;
  SoundFile calm;

  float volTense = 0.0;
  float volCalm = 1.0;

  boolean switching = false;
  boolean toTense = false;
  boolean started = false;

  int fadeDuration = 1000;       // milliseconds
  int fadeStartTime = 0;

  MusicManage(SoundFile tense, SoundFile calm) {

    this.tense = tense;
    this.calm = calm;
  }


  void playMusic() {

    if (switching) {
      float t = (millis() - fadeStartTime) / float(fadeDuration); //time since pressing key divided by the duration

      if (t >= 1) t = 1;

      if (toTense) {

        volTense = t;
        volCalm  = 1 - t;
      } else {     // toCalm

        volTense = 1 - t;
        volCalm  = t;
      }

      tense.amp(volTense);
      calm.amp(volCalm);

      if (t == 1) {
        switching = false;   // fade finished
      }
    }
  }

  void switchMusic() {
    if (!switching) {
      switching = true;

      // determine fade direction
      toTense = (volTense == 0);

      fadeStartTime = millis();
    }
  }

  void tenseMusic() {
    if (volTense<0.5) {
      toTense = true;
      switching = true;
      fadeStartTime = millis();
    }
  }

  void calmMusic() {

    toTense = false;

    fadeStartTime = millis();
  }

  void startMusic() {
    if (!started) {
      started = true;
      tense.loop();
      calm.loop();
      tense.amp(volTense);
      calm.amp(volCalm);
    }
  }

  void endMusic() {
    tense.stop();
    calm.stop();
  }

  void stopMusic() {
    tense.stop();
    calm.stop();
    started = false;  // allow startMusic() to restart properly
    switching = false;
  }
}
