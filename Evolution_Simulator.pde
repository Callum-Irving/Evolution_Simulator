import g4p_controls.*;

Metrics m;
World w;
boolean loop = true;
int populationSize = 10;

// Panning and zooming variables
float xOff = 0, yOff = 0;
float scale = 1.0;

// If true then the SHIFT key must be pressed to pan.
static final boolean SHIFT_TO_PAN = true;

// The mouse button used to pan.
static final int PAN_BUTTON = LEFT;

void setup() {
  size(1280, 720);
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
  background(0);
  w.update(m);
  scale(scale);
  translate(xOff, yOff);
}
//
void zoom(float value) {
  float prevX = this.mouseX();
  float prevY = this.mouseY();
  if (value < 0) {
    scale *= 1.2;
  } else if (value > 0) {
    scale /= 1.2;
  }
  xOff -= (prevX - this.mouseX());
  yOff -= (prevY - this.mouseY());
}
float mouseX() {
  return mouseX / this.scale - this.xOff;
}

float mouseY() {
  return mouseY / this.scale - this.yOff;
}
void dragged() {
  if (mousePressed && mouseButton == PAN_BUTTON &&
    (SHIFT_TO_PAN ? (keyPressed && keyCode == SHIFT) : true)) {
    // Pan using middle mouse button. Can be changed to right click if you
    // don't have a middle mouse button.
    xOff -= (pmouseX - mouseX) / this.scale;
    yOff -= (pmouseY - mouseY) / this.scale;
  }
}
