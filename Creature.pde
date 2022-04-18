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

  // When energy hits 0, the creature dies.
  float energy = INITIAL_ENERGY;

  // Age-related fields:
  int generation;
  float age = 0;

  Creature(PVector pos, float senseDistance, float speed, float size, int generation) {
    this.pos = pos;
    this.energy = INITIAL_ENERGY;
    this.senseDistance = senseDistance;
    this.speed = speed;
    this.size = size;
    this.generation = generation;
  }

  // TODO: Make random ranges parametric.
  Creature randomCreature(int width, int height) {
    PVector pos = new PVector(random(width), random(height));
    float senseDistance = random(5, 15);
    float speed = random(5, 15);
    float size = random(5, 15);
    int generation = 0;
    return new Creature(pos, senseDistance, speed, size, generation);
  }

  // Actions a creature can take:
  // - Eat food
  // - Eat creature
  // - Move towards food/creature
  // - Move randomly
  void step() {
  }

  // Returns the cost per time step.
  float calculateEnergyCost() {
    return SENSE_EXP * SPEED_EXP * this.speed + SIZE_EXP * this.size;
  }
}
