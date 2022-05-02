import g4p_controls.*;

Metrics m;
World w;
boolean loop = true;

void setup() {
  size(1280, 720);
  //frameRate(15);
  w = new World(width, height, 10, 10);
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
  println(m.avEnergy());
}
