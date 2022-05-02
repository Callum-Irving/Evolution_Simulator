import g4p_controls.*;

Metrics m;
World w;
boolean loop = true;
int populationSize = 10;

// Panning and zooming variables
float xOff = 0, yOff = 0;
float scale = 1.0;

PImage bg;

void setup() {
  size(1280, 720);
  bg = loadImage("minecraft_dirt.png");
  bg.resize(width, height);
  //frameRate(15);
  w = new World(width, height, 10, populationSize);
  m = new Metrics();
  createGUI();

  // Setting initial values from GUI
  SENSE_EXP = senseSlider.getValueF();
  SPEED_EXP = speedSlider.getValueF();
  SIZE_EXP = sizeSlider.getValueF();
  INITIAL_ENERGY = iniEnergySlider.getValueF();
  WANDER_STRENGTH = wanderStrengthSlider.getValueF();
  BABY_THRESH = babyThresholdSlider.getValueF();
  MUT_SD = mutationRateSlider.getValueF();
}

void draw() {
  scale(scale);
  translate(xOff, yOff);
  background(bg);
  w.update(m);
}

void mouseWheel(MouseEvent e) {
  float value = e.getCount();
  float prevX = mouseX();
  float prevY = mouseY();
  if (value < 0) {
    scale *= 1.2;
  } else if (value > 0) {
    scale /= 1.2;
  }
  xOff -= (prevX - mouseX());
  yOff -= (prevY - mouseY());
}
float mouseX() {
  return mouseX / scale - xOff;
}

float mouseY() {
  return mouseY / scale - yOff;
}
void mouseDragged() {
  xOff -= (pmouseX - mouseX) / scale;
  yOff -= (pmouseY - mouseY) / scale;
}
