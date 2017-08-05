class RippleSystem {

  ArrayList<Ripple> ripples;
  PVector origin;
  float lifespan;

  int count;

  RippleSystem(PVector position, float force) {
    ripples = new ArrayList<Ripple>();
    origin = position;
    lifespan = 256 * force;

    count = (int)random(90);
  }

  void run(float force, int addCount) {
    lifespan = 256 * force;

    count = count + addCount;
    if (90 < count) {
      count = 0;
      addRipple();
    }

    for (int i = ripples.size()-1; i >= 0; i--) {
      Ripple r = ripples.get(i);
      r.run();
      if (r.isDead()) ripples.remove(i);
    }
  }

  void run(float force) {
    lifespan = 256 * force;

    count = count + 1;
    if (90 < count) {
      count = 0;
      addRipple();
    }

    for (int i = ripples.size()-1; i >= 0; i--) {
      Ripple r = ripples.get(i);
      r.run();
      if (r.isDead()) ripples.remove(i);
    }
  }

  void addRipple() {
    ripples.add(new Ripple(origin.x, origin.y, lifespan));
  }
}