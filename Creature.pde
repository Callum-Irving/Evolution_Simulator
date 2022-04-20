float SENSE_EXP = 1.0;
float SPEED_EXP = 2.0;
float SIZE_EXP = 3.0;
float INITIAL_ENERGY = 100.0;
float WANDER_STRENGTH = 0.3;
float BABY_THRESH = 150.0;

// Standard deviation of mutations
float MUT_SD = 1.0;

class Creature implements Positioned {
  PVector pos;
  PVector dir;

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
  Creature(PVector pos, PVector dir, float senseDistance, float speed, float size, int generation, color col) {
    this.pos = pos;
    this.dir = dir;
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
    this.dir = PVector.fromAngle(random(TWO_PI));
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
  boolean step(Positioned nearestFood, float maxWidth, float maxHeight) {
    if (this.dead) return false;

    boolean ateFood = false;
    float distance = PVector.dist(this.pos, nearestFood.getPosition());
    if (distance < this.size + nearestFood.getRadius()) {
      // Eat the food.
      this.energy += nearestFood.getEnergyValue();
      ateFood = true;
    } else if (distance < this.senseDistance) {
      // Move towards the food.
      this.moveTowards(nearestFood.getPosition());
    } else {
      // Move randomly.
      this.wander();
    }

    // Keep creature inside the world area.
    this.constrainPos(0.0, 0.0, maxWidth, maxHeight);

    // TODO: Make baby if energy and age are high enough
    if (this.energy > BABY_THRESH) this.makeBaby(maxWidth, maxHeight);

    // Use energy:
    this.energy -= this.calculateEnergyCost();
    if (this.energy < 0) this.dead = true;
    return ateFood;
  }

  Creature makeBaby(float maxWidth, float maxHeight) {
    PVector pos = new PVector(random(maxWidth), random(maxHeight));
    PVector dir = PVector.fromAngle(random(TWO_PI));
    float senseDistance = this.senseDistance + randomGaussian() * MUT_SD;
    float speed = this.speed + randomGaussian() * MUT_SD;
    float size = this.size + randomGaussian() * MUT_SD;
    int generation = this.generation + 1;
    // TODO: mutate color
    color col = this.col;
    return new Creature(pos, dir, senseDistance, speed, size, generation, col);
  }

  // Returns the cost per time step.
  float calculateEnergyCost() {
    return SENSE_EXP * SPEED_EXP * this.speed + SIZE_EXP * this.size;
  }

  public void moveTowards(PVector pt) {
    float newAngle = PVector.sub(pt, this.pos).heading();
    this.dir = PVector.fromAngle(newAngle);
    this.pos.add(PVector.mult(this.dir, this.speed));
  }

  public void wander() {
    // TODO: Try out randomGaussian to see if it looks more natural.
    this.dir.rotate(random(-WANDER_STRENGTH, WANDER_STRENGTH));
    this.pos.add(PVector.mult(this.dir, this.speed));
  }

  public void constrainPos(float minX, float minY, float maxX, float maxY) {
    this.pos.x = constrain(this.pos.x, minX, maxX);
    this.pos.y = constrain(this.pos.y, minY, maxY);
  }

  public PVector getPosition() {
    return this.pos;
  }

  public float getRadius() {
    return this.size;
  }

  public float getEnergyValue() {
    return this.energy;
  }
}
