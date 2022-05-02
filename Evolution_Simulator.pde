import g4p_controls.*;

Metrics m;
World w;
boolean loop = true;
int populationSize = 10;

// Panning and zooming variables
float xOff = 0, yOff = 0;
float scale = 1.0;

void setup() {
  size(1280, 720);
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
}
