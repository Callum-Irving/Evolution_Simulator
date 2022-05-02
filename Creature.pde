float SENSE_EXP;
float SPEED_EXP;
float SIZE_EXP;
float INITIAL_ENERGY;
float WANDER_STRENGTH;
float BABY_THRESH;
boolean SHOW_SENSE_DISTANCE = false;
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
  MutableColor col;

  // When energy hits 0, the creature dies.
  float energy = INITIAL_ENERGY;

  // Age-related fields:
  int generation;
  float age = 0;
  boolean dead = false;

  // Constructor with all parameters passed in.
  Creature(PVector pos, PVector dir, float senseDistance, float speed, float size, int generation, MutableColor col) {
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
    //this.senseDistance = random(25, 50);
    this.senseDistance = random(100, 200);
    this.speed = random(5, 15);
    this.size = random(5, 15);
    this.col = new MutableColor((int)random(255), (int)random(255), (int)random(255));
    this.generation = 0;
  }

  // Actions a creature can take:
  // - Eat food
  // - Eat creature
  // - Move towards food/creature
  // - Move randomly
  boolean update(ArrayList<Creature> population, Positioned nearestFood, float maxWidth, float maxHeight) {
    if (this.dead) return false;

    if (nearestFood == null) {
      this.wander();
      // Keep creature inside the world area.
      this.constrainPos(0.0, 0.0, maxWidth, maxHeight);
      // Make baby if energy and age are high enough
      if (this.energy > BABY_THRESH) population.add(this.makeBaby(maxWidth, maxHeight));
      this.energy -= this.calculateEnergyCost();
      if (this.energy < 0) this.dead = true;
      this.age++;
      return false;
    }

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

    // Shows sense distance of creatures. 
    if (SHOW_SENSE_DISTANCE) {
      fill (0, 255, 255, 50);
      circle(this.pos.x, this.pos.y, this.senseDistance * 2);
    }
    fill(this.col.getColor());

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

    // Draw eye.
    PVector eyePos = PVector.add(this.pos, PVector.mult(this.dir, this.size / 2));
    fill(255);
    circle(eyePos.x, eyePos.y, this.senseDistance / 3);
    PVector pupilPos = PVector.add(eyePos, PVector.mult(this.dir, this.senseDistance / 12));
    fill(0);
    circle(pupilPos.x, pupilPos.y, this.senseDistance / 6);
  }

  // Make a slightly mutated copy of a creature.
  Creature makeBaby(float maxWidth, float maxHeight) {
    PVector pos = new PVector(random(maxWidth), random(maxHeight));
    PVector dir = PVector.fromAngle(random(TWO_PI));
    float senseDistance = this.senseDistance + randomGaussian() * MUT_SD;
    float speed = this.speed + randomGaussian() * MUT_SD;
    float size = this.size + randomGaussian() * MUT_SD;
    int generation = this.generation + 1;
    MutableColor col = new MutableColor(this.col);

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
