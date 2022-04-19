float SENSE_EXP = 1.0;
float SPEED_EXP = 2.0;
float SIZE_EXP = 3.0;
float INITIAL_ENERGY = 100.0;

class Creature {
  PVector pos;

  // Parameters that can be mutated:
  float senseDistance;
  float speed;
  float size;
  // Using HSB color scheme
  color col;

  // When energy hits 0, the creature dies.
  float energy = INITIAL_ENERGY;

  // Age-related fields:
  int generation;
  float age = 0;
  boolean dead = false;

  // Constructor with all parameters passed in.
  Creature(PVector pos, float senseDistance, float speed, float size, int generation, color col) {
    this.pos = pos;
    this.energy = INITIAL_ENERGY;
    this.senseDistance = senseDistance;
    this.speed = speed;
    this.size = size;
    this.generation = generation;

    this.col = col;
  }

  // Random constructor.
  // TODO: Make random ranges parametric.
  Creature(int maxWidth, int maxHeight) {
    this.pos = new PVector(random(maxWidth), random(maxHeight));
    this.senseDistance = random(5, 15);
    this.speed = random(5, 15);
    this.size = random(5, 15);
    this.generation = 0;
  }

  // Actions a creature can take:
  // - Eat food
  // - Eat creature
  // - Move towards food/creature
  // - Move randomly
  void step() {
    // if dist(food) < this.size / 2 (radius)
    // if can see food: move towards
    // else, move randomly
    // if energy is high enough, create offspring

    // Use energy:
    this.energy -= this.calculateEnergyCost();
    if (this.energy < 0) this.dead = true;
  }

  Creature makeBaby(int maxWidth, int maxHeight) {
    PVector pos = new PVector(random(maxWidth), random(maxHeight));
    float senseDistance = this.senseDistance + randomGaussian();
    float speed = this.speed + randomGaussian();
    float size = this.size + randomGaussian();
    int generation = this.generation + 1;
    // TODO: mutate color
    color col = this.col;
    return new Creature(pos, senseDistance, speed, size, generation, col);
  }

  // Returns the cost per time step.
  float calculateEnergyCost() {
    return SENSE_EXP * SPEED_EXP * this.speed + SIZE_EXP * this.size;
  }
}
