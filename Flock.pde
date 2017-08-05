class Flock {

  ArrayList<Boid> boids;
  ArrayList<Boid> allBoids;
  PImage img;

  Flock(ArrayList<Boid> allBoids_, PImage img_) {
    allBoids = allBoids_;
    img = img_;
    boids = new ArrayList<Boid>();

    //int boidsLen = (int)random(3, 5);
    int boidsLen = 3;
    for (int i = 0; i < boidsLen; i++) addBoid();
  }

  void run() {
    for (Boid b : boids) b.run(allBoids, boids);
  }

  void addBoid() {
    Boid b = new Boid(random(width), 0, img);
    boids.add(b);
    allBoids.add(b);
  }
}