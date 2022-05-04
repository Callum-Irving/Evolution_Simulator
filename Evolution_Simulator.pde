import g4p_controls.*;

World w;
boolean loop = true;
int MIN_CREATURES;
int MAX_CREATURES;
int NUM_FOOD;

PImage bg;

// Inital values
float SENSE_EXP_INI = 0.1;
float SPEED_EXP_INI = 0.2;
float SIZE_EXP_INI = 0.7;
float INITIAL_ENERGY_INI = 100;
float WANDER_STRENGTH_INI = 0.5;
float BABY_THRESH_INI = 140;
float MUT_SD_INI = 1;
int MIN_CREATURES_INI = 10;
int MAX_CREATURES_INI = 100;
int NUM_FOOD_INI = 10;

void resetValues() {
  SENSE_EXP = SENSE_EXP_INI;
  SPEED_EXP = SPEED_EXP_INI;
  SIZE_EXP = SIZE_EXP_INI;
  INITIAL_ENERGY = INITIAL_ENERGY_INI;
  WANDER_STRENGTH = WANDER_STRENGTH_INI;
  BABY_THRESH = BABY_THRESH_INI;
  MUT_SD = MUT_SD_INI;
  MIN_CREATURES = MIN_CREATURES_INI;
  MAX_CREATURES = MAX_CREATURES_INI;
  NUM_FOOD = NUM_FOOD_INI;
}

void syncGUI() {
  senseSlider.setValue(SENSE_EXP);
  speedSlider.setValue(SPEED_EXP);
  sizeSlider.setValue(SIZE_EXP);
  iniEnergySlider.setValue(INITIAL_ENERGY);
  wanderStrengthSlider.setValue(WANDER_STRENGTH);
  babyThresholdSlider.setValue(BABY_THRESH);
  mutationRateSlider.setValue(MUT_SD);
  maxCreaturesSlider.setValue(MAX_CREATURES);
  minCreaturesSlider.setValue(MIN_CREATURES);
  numFoodSlider.setValue(NUM_FOOD);
}

void setup() {
  size(1280, 720);
  bg = loadImage("minecraft_dirt.png");
  bg.resize(width, height);
  w = new World(width, height, 10, MIN_CREATURES);
  createGUI();
  resetValues();
  syncGUI();
}

void draw() {
  background(bg);
  w.update();
}
