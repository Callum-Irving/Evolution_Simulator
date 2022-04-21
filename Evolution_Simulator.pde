World w;
Metrics m;

void setup() {
  size(1000, 1000);

  frameRate(15);
  w = new World(width, height, 10, 40);
  m = new Metrics();
}

void draw() {
  background(0);
  w.update(m);
}
