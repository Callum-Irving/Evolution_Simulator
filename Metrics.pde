class Metrics {
  float senseDistance = 0;
  float speed = 0;
  float size = 0;
  float age = 0;
  int maxGen = 0;

  int numCreatures = 0;

  public float avSize() {
    return this.size;
  }

  public float avSense() {
    return this.senseDistance;
  }

  public float avAge() {
    return this.age;
  }

  void reset() {
    this.senseDistance = 0;
    this.speed = 0;
    this.size = 0;
    this.age = 0;
    this.maxGen = 0;
    this.numCreatures = 0;
  }

  void addToTotal(Creature c) {
    this.senseDistance += c.senseDistance;
    this.speed += c.speed;
    this.size += c.size;
    this.age += c.age;
    if (c.generation > this.maxGen)
      this.maxGen = c.generation;
    this.numCreatures++;
  }

  void calculateTotals() {
    this.senseDistance /= (float)this.numCreatures;
    this.speed /= (float)this.numCreatures;
    this.size /= (float)this.numCreatures;
    this.age /= (float)this.numCreatures;
  }

  void log() {
    println("Average sense distance:", this.senseDistance);
    println("Average speed:", this.speed);
    println("Average size:", this.size);
    println("Average age:", this.age);
    println("Max gen:", this.maxGen);
  }
}
