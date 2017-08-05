class ShoeSystem {

  ArrayList<Shoe> shoes;

  ShoeSystem() {
    shoes = new ArrayList<Shoe>();
  }

  void run() {
    for (Shoe s : shoes) {
      s.run(shoes);
    }
  }

  void addShoe(int i) {
    shoes.add(new Shoe(width / 2 + 20 * i, height - 10));
  }
  
  void addShoe(float x, float y) {
    shoes.add(new Shoe(x, y));
  }

  void mousePressed() {
    for (Shoe s : shoes) {
      s.clicked(mouseX, mouseY);
    }
  }

  void mouseReleased() {
    for (Shoe s : shoes) {
      s.stopDragging();
    }
  }
}