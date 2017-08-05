class FlockSystem {

  ArrayList<Flock> flocks;
  ArrayList<Boid> allBoids;
  int flockNum;

  PImage[] imgs;
  PImage img;

  FlockSystem() {
    flocks = new ArrayList<Flock>();
    allBoids = new ArrayList<Boid>();

    flockNum = 0;

    imgs = new PImage[3];
    for (int i = 0; i < 3; i++ ) imgs[i] = loadImage("kingyo" + i + ".png");
  }

  void run() {
    for (Flock f : flocks) f.run();
  }

  void addFlock() {
    flockNum++;

    img = imgs[flockNum % 3];
    Flock f = new Flock(allBoids, img);
    flocks.add(f);
  }
}
