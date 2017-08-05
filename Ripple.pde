class Ripple {

  PVector origin;
  float d;
  float dVel;
  float lifespan;

  float startRad1 = HALF_PI - EIGHTH_PI;
  float startRad2 = -HALF_PI - EIGHTH_PI;
  float endRad1 = HALF_PI + EIGHTH_PI;
  float endRad2 = -HALF_PI + EIGHTH_PI;

  Ripple(float x, float y, float l) {
    origin = new PVector(x, y);
    d = 0;
    dVel = 1;
    lifespan = l;
  }

  void run() {
    update();
    rs.add(this);
  }

  void update() {
    lifespan -= 1.0;
    d += dVel;
  }

  boolean isDead() {
    if (lifespan <= 0.0) return true;
    else return false;
  }

  void displayShadow() {
    noFill();
    stroke(0, lifespan);
    ellipse(origin.x, origin.y - shadowLenR, d, d);
  }

  void display() {
    noFill();
    stroke(255, lifespan);
    arc(origin.x, origin.y, d + 10, d + 10, startRad1, endRad1);
    arc(origin.x, origin.y, d - 10, d - 10, startRad2, endRad2);
    stroke(255, lifespan / 2);
    ellipse(origin.x, origin.y, d, d);
  }
}