float SENSE_EXP = 0.1;
float SPEED_EXP = 0.2;
float SIZE_EXP = 0.7;
float INITIAL_ENERGY = 100.0;
float WANDER_STRENGTH = 0.5;
float BABY_THRESH = 140.0;

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
    this.senseDistance = random(25, 50);
    this.speed = random(5, 15);
    this.size = random(5, 15);
    this.col = color(random(255), random(255), random(255));
    this.generation = 0;
  }

  // Actions a creature can take:
  // - Eat food
  // - Eat creature
  // - Move towards food/creature
  // - Move randomly
  boolean update(ArrayList<Creature> population, Positioned nearestFood, float maxWidth, float maxHeight) {
    if (this.dead) return false;

    boolean ateFood = false;
    float distance = PVector.dist(this.pos, nearestFood.getPosition());

    if (distance > this.senseDistance || nearestFood.eaten()) {
      // If we can't see it or it's been eaten already, wander.
      this.wander();
    } else if (!this.canEat(nearestFood)) {
      if (nearestFood instanceof Creature && this.canEatUs((Creature)nearestFood)) {
        // If it can eat us, run away.
        this.runAwayFrom(nearestFood.getPosition());
      } else {
        // If we can't eat it but it can't eat us, wander.
        this.wander();
      }
    } else if (distance < this.size + nearestFood.getRadius()) {
      // Eat the food.
      this.energy += nearestFood.getEnergyValue();
      ateFood = true;
    } else {
      // Move towards the food.
      this.moveTowards(nearestFood.getPosition());
    }

    // Keep creature inside the world area.
    this.constrainPos(0.0, 0.0, maxWidth, maxHeight);

    // Make baby if energy and age are high enough
    if (this.energy > BABY_THRESH) population.add(this.makeBaby(maxWidth, maxHeight));

    // Use energy:
    this.energy -= this.calculateEnergyCost();
    if (this.energy < 0) this.dead = true;
    this.age++;
    return ateFood;
  }

  void show() {
    noStroke();
    fill(this.col);

    // Head of creature.
    float heading = this.dir.heading();
    arc(this.pos.x, this.pos.y, this.size * 2, this.size * 2, heading - HALF_PI, heading + HALF_PI, PIE);

    // Left side of the circle.
    PVector p1 = this.dir.copy();
    p1.rotate(-HALF_PI);
    p1.mult(this.size);
    p1.add(this.pos);

    // Right side of the circle.
    PVector p2 = this.dir.copy();
    p2.rotate(HALF_PI);
    p2.mult(this.size);
    p2.add(this.pos);

    // End of the tail.
    PVector p3 = this.dir.copy();
    p3.rotate(PI);
    p3.mult(this.speed * this.size / 3);
    p3.add(this.pos);

    triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
  }

  Creature makeBaby(float maxWidth, float maxHeight) {
    PVector pos = new PVector(random(maxWidth), random(maxHeight));
    PVector dir = PVector.fromAngle(random(TWO_PI));
    float senseDistance = this.senseDistance + randomGaussian() * MUT_SD;
    float speed = this.speed + randomGaussian() * MUT_SD;
    float size = this.size + randomGaussian() * MUT_SD;
    int generation = this.generation + 1;
    int rOff = int(random(-5, 5)) << 16;
    int gOff = int(random(-5, 5)) << 8;
    int bOff = int(random(-5, 5));
    int tOff = rOff | gOff | bOff;
    color col = this.col + tOff;

    // TODO: Make this value a variable somehow.
    this.energy -= 70;

    return new Creature(pos, dir, senseDistance, speed, size, generation, col);
  }

  // Returns the cost per time step.
  float calculateEnergyCost() {
    return 0.005 * pow(this.senseDistance, SENSE_EXP) * pow(this.speed, SPEED_EXP) * pow(this.size, SIZE_EXP);
  }

  private void moveTowards(PVector pt) {
    this.pointTo(pt);
    this.pos.add(PVector.mult(this.dir, this.speed));
  }

  private void runAwayFrom(PVector pt) {
    this.pointTo(pt);
    this.dir.rotate(PI);
    this.pos.add(PVector.mult(this.dir, this.speed));
  }

  private void pointTo(PVector pt) {
    float newDir = PVector.sub(pt, this.pos).heading();
    this.dir = PVector.fromAngle(newDir);
  }

  private void wander() {
    // TODO: Try out randomGaussian to see if it looks more natural.
    this.dir.rotate(random(-WANDER_STRENGTH, WANDER_STRENGTH));
    this.pos.add(PVector.mult(this.dir, this.speed));
  }

  private void constrainPos(float minX, float minY, float maxX, float maxY) {
    if (this.pos.x < minX) {
      this.pos.x = minX;
      this.dir = PVector.fromAngle(0);
    } else if (this.pos.x > maxX) {
      this.pos.x = maxX;
      this.dir = PVector.fromAngle(PI);
    }

    if (this.pos.y < minY) {
      this.pos.y = minY;
      this.dir = PVector.fromAngle(HALF_PI);
    } else if (this.pos.y > maxY) {
      this.pos.y = maxY;
      this.dir = PVector.fromAngle(-HALF_PI);
    }
  }

  private boolean canEatUs(Creature other) {
    return other.getRadius() > this.size * 1.2;
  }

  private boolean canEat(Positioned other) {
    if (other instanceof Creature && other.getRadius() * 1.2 >= this.size) return false;
    return true;
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

  public boolean eaten() {
    return this.dead;
  }

  public void getEaten() {
    this.dead = true;
  }
}
