class Shoe {

  PVector position;
  float r;

  float nearestDistance;
  float force;
  float theta;
  float amplitude;

  boolean dragging = false;
  boolean rollover = false;
  PVector dragOffset;

  RippleSystem rs;

  Shoe(float x, float y) {
    position = new PVector(x, y);
    r = 10.0;
    dragOffset = new PVector(0.0,0.0);

    nearestDistance = 10000;
    force = 0;
    theta = random(0, PI);
    amplitude = random(1, 2);

    rs = new RippleSystem(position, force);
  }

  void run(ArrayList<Shoe> shoes) {
    nearestDistance = 10000;
    calcForce(shoes);
    drag();
    hover(mouseX, mouseY);
    display();

    rs.run(force);
  }

  void calcForce(ArrayList<Shoe> shoes) {
    for (Shoe other : shoes) {
      float d = PVector.dist(position, other.position);
      if (d < nearestDistance && d > 0) nearestDistance = d;
    }

    force = nearestDistance / diagonal;
    theta += (0.001 * amplitude);
    force = (abs(sin(theta)) * 5) * force;
  }

  void display() {
    noStroke();
    if (dragging) fill(128, 32);
    else if (rollover) fill(128, 128);
    //else noFill();
    else fill(128, 64);
    ellipse(position.x, position.y, 5, 5);
  }

  // The methods below are for mouse interaction
  void clicked(int mx, int my) {
    float d = dist(mx, my, position.x, position.y);
    if (d < r) {
      dragging = true;
      dragOffset.x = position.x - mx;
      dragOffset.y = position.y - my;
    }
  }

  void hover(int mx, int my) {
    float d = dist(mx, my, position.x, position.y);
    if (d < 2.5) rollover = true;
    else rollover = false;
  }

  void stopDragging() {
    dragging = false;
  }

  void drag() {
    if (dragging) {
      position.x = mouseX + dragOffset.x;
      position.y = mouseY + dragOffset.y;
    }
  }
}
