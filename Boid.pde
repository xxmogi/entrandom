class Boid {

  PVector position;
  PVector velocity;
  float velMag;
  float preVelMag;
  PVector acceleration;

  float r;
  float rM2;
  float rD2;
  float rD20;
  float maxforce;
  float maxspeed;
  float maxspeedM2;

  float d;

  PVector sep;
  float desiredseparation;

  ArrayList<Boid> visibleBoids;
  int visibleBoidsCount;
  float sightDistance;
  float periphery;
  PVector comparison;
  float fDiff;

  PVector ali;
  PVector coh;

  PVector diff;
  PVector desired;
  PVector steer;
  PVector sum;

  float tx, ty;

  float theta;
  color col;
  PImage img;

  RippleSystem rs;

  Boid(float x, float y, PImage img_) {
    position = new PVector(x, y);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    velMag = velocity.mag();
    preVelMag = 0;
    acceleration = new PVector(0, 0);

    r = random(20.0, 40.0);
    rM2 = r * 2;
    rD2 = r / 2;
    rD20 = r / 20;
    maxspeed = 3;
    maxspeedM2 = maxspeed * 2;
    maxforce = 0.05;

    visibleBoids = new ArrayList<Boid>();
    visibleBoidsCount = 0;
    sightDistance = 100;
    periphery = QUARTER_PI * 3;

    tx = random(10000);
    ty = random(10000);

    col = color(175);
    img = img_;

    rs = new RippleSystem(position, velocity.mag() / maxspeed);
  }

  void run(ArrayList<Boid> allBoids, ArrayList<Boid> boids) {
    //flock(allBoids, boids);
    seekShoe();
    update();
    borders();
    render();

    velMag = velocity.mag();
    if (preVelMag < velMag) rs.run(velMag / maxspeedM2, 5);
    else rs.run(velMag / maxspeedM2);
    preVelMag = velMag;
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, rD20);
    acceleration.add(f);
  }

  void flock(ArrayList<Boid> allBoids, ArrayList<Boid> boids) {
    sep = separate(allBoids);
    sep.mult(2.0);
    applyForce(sep);

    view(boids);
    visibleBoidsCount = visibleBoids.size();

    if (0 < visibleBoidsCount) {
      ali = align(boids);
      coh = cohesion(boids);

      ali.mult(1.0);
      coh.mult(1.0);

      applyForce(ali);
      applyForce(coh);
    } else {
      wander();
    }
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  void seekShoe() {
    for (Shoe s : ss.shoes) {
      d = PVector.dist(s.position, position);
      desired = PVector.sub(s.position, position);
      desired.setMag(maxspeed * diagonal / d);

      if (d < 100) desired.mult(-1);
      else if (d < 200) desired = new PVector(desired.y, -desired.x);

      steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      steer.mult(s.force);
      applyForce(steer);
    }
  }

  PVector seek(PVector target) {
    desired = PVector.sub(target, position);
    desired.setMag(maxspeed);

    steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
  }

  PVector separate (ArrayList<Boid> boids) {
    desiredseparation = r;
    steer = new PVector(0, 0, 0);
    int count = 0;

    for (Boid b : boids) {
      d = PVector.dist(position, b.position);
      if ((d > 0) && (d < desiredseparation)) {
        diff = PVector.sub(position, b.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }

    if (count > 0) steer.div((float)count);

    if (steer.mag() > 0) {
      steer.setMag(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }

    return steer;
  }

  void view (ArrayList<Boid> boids) {
    visibleBoids = new ArrayList<Boid>();

    for (Boid b : boids) {
      comparison = PVector.sub(b.position, position);
      fDiff = PVector.angleBetween(comparison, velocity);

      d = PVector.dist(position, b.position);

      if (fDiff < periphery && d > 0 && d < sightDistance) visibleBoids.add(b);
    }

    // float currentHeading = velocity.heading();
    // pushMatrix();
    // translate(position.x, position.y);
    // rotate(currentHeading);
    // fill(255, 50);
    // arc(0, 0, sightDistance * 2, sightDistance * 2, -periphery, periphery);
    // popMatrix();
  }

  PVector align (ArrayList<Boid> boids) {
    sum = new PVector(0, 0);
    for (Boid b : boids) {
      d = PVector.dist(position, b.position);
      sum.add(b.velocity);
    }

    sum.div((float)visibleBoidsCount);
    sum.setMag(maxspeed);
    steer = PVector.sub(sum, velocity);
    steer.limit(maxforce);
    return steer;
  }

  PVector cohesion (ArrayList<Boid> boids) {
    sum = new PVector(0, 0);
    for (Boid b : boids) {
      d = PVector.dist(position, b.position);
      sum.add(b.position);
    }
    sum.div(visibleBoidsCount);
    return seek(sum);
  }

  void wander() {
    applyForce(new PVector (map(noise(tx), 0, 1, -0.1, 0.1), map(noise(ty), 0, 1, -0.1, 0.1)));

    tx += 0.03;
    ty += 0.03;
  }

  void borders() {
    if (position.x < -rM2) position.x = width + rM2;
    if (position.y < -rM2) position.y = height + rM2;
    if (position.x > width + rM2) position.x = -rM2;
    if (position.y > height + rM2) position.y = -rM2;
  }

  void render() {
    theta = velocity.heading() + PI/2;
    fill(col);
    stroke(0);

    pushMatrix();

    translate(position.x, position.y);
    rotate(theta);
    imageMode(CENTER);
    tint(0, 255);
    image(img, 0, 0, r, rM2);

    rotate(-theta);
    translate(0, shadowLen);
    rotate(theta);
    noTint();
    image(img, 0, 0, r, rM2);

    popMatrix();
  }
}
