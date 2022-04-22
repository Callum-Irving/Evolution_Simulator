World w;
import g4p_controls.*;

void setup() {
  size(1280, 700);
  //frameRate(60);
  w = new World(width, height, 10, 15);
  createGUI();
}

void draw() {
  background(0);
  w.step();
}
