World w;

void setup() {
  size(400, 400);
  frameRate(15);
  w = new World(width, height, 50, 5);
}

void draw() {
  background(0);
  w.step();
}
