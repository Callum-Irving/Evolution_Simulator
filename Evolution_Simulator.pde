import g4p_controls.*;

World w;
boolean loop = true;
int populationSize = 10;

PImage bg;

// Inital values
float SENSE_EXP_INI = 0.1;
float SPEED_EXP_INI = 0.2;
float SIZE_EXP_INI = 0.7;
float INITIAL_ENERGY_INI = 100;
float WANDER_STRENGTH_INI = 0.5;
float BABY_THRESH_INI = 140;
float MUT_SD_INI = 1;
int MAX_CREATURES_INI = 100;

void resetGUI() {
  senseSlider.setValue(SENSE_EXP_INI);
  speedSlider.setValue(SPEED_EXP_INI);
  sizeSlider.setValue(SIZE_EXP_INI);
  iniEnergySlider.setValue(INITIAL_ENERGY_INI);
  wanderStrengthSlider.setValue(WANDER_STRENGTH_INI);
  babyThresholdSlider.setValue(BABY_THRESH_INI);
  mutationRateSlider.setValue(MUT_SD_INI);
  maxCreaturesSlider.setValue(MAX_CREATURES_INI);
}

void syncGUI() {
  SENSE_EXP = senseSlider.getValueF();
  SPEED_EXP = speedSlider.getValueF();
  SIZE_EXP = sizeSlider.getValueF();
  INITIAL_ENERGY = iniEnergySlider.getValueF();
  WANDER_STRENGTH = wanderStrengthSlider.getValueF();
  BABY_THRESH = babyThresholdSlider.getValueF();
  MUT_SD = mutationRateSlider.getValueF();
  MAX_CREATURES = maxCreaturesSlider.getValueI();
}

void setup() {
  size(1280, 720);
  bg = loadImage("minecraft_dirt.png");
  bg.resize(width, height);
  w = new World(width, height, 10, populationSize);
  createGUI();
  resetGUI();
  syncGUI();
}

void draw() {
  background(bg);
  w.update();
}
