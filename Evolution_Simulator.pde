import g4p_controls.*;

Metrics m;
World w;

void setup() {
  size(1280, 720);
  //frameRate(15);
  w = new World(width, height, 10, 10);
  m = new Metrics();
  createGUI();
}

void draw() {
  background(0);
  w.update(m);
}
