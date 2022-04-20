World w;

void setup() {
  size(400, 400);
  frameRate(15);
  w = new World(width, height, 30, 15);
}

void draw() {
  background(0);
  w.step();
}
