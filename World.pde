class World {
  int width, height;
  ArrayList<FoodPellet> food;
  ArrayList<Creature> population;

  // If too many creatures die, this population will be maintained.
  int minPopulation;

  // The constant number of food pellets. If one is eaten, a new one
  // is created.
  int numFood;

  World(int width, int height, int numFood, int populationSize) {
    this.width = width;
    this.height = height;
    this.numFood = numFood;
    this.food = new ArrayList<FoodPellet>(numFood);
    this.population = new ArrayList<Creature>(populationSize);
    this.minPopulation = populationSize;

    // Initialize population
    for (int i = 0; i < populationSize; i++)
      this.population.add(new Creature(width, height));

    // Create food pellets
    for (int i = 0; i < numFood; i++)
      this.food.add(new FoodPellet(width, height));
  }

  void step() {
    // Create K-D tree to make nearest-neighbour checks quicker.
    KDTree tree = new KDTree();
    tree.insertList(this.population);
    tree.insertList(this.food);

    // Update each creature
    for (Creature c : this.population) {
      // Find the closest node that the creature can eat:
      Positioned nearest = tree.nthNearest(1, c);
      while (nearest instanceof Creature && ((Creature)nearest).size >= c.size) {
        nearest = tree.nthNearest(2, c);
      }

      // TODO: Optimize the following mess:

      if (nearest == null) {
        // Wander around randomly.
      } else {
        // The distance to the nearest food (food pellet or creature).
        float distance = PVector.dist(nearest.getPosition(), c.getPosition());
        if (distance > c.senseDistance) {
          // Wander around randomly.
        } else if (distance < c.getRadius() + nearest.getRadius()) {
          // Eat and delete item.
          tree.removeItem(nearest);
          this.eat(c, nearest);
        } else {
          // Move towards the food.
          c.moveTowards(nearest.getPosition());
        }
      }

      // Keep creature within the world area.
      c.constrainPos(0, 0, this.width, this.height);
    }

    // Make babies.

    // Keep population at minimum amount.
    while (this.population.size() < this.minPopulation)
      this.population.add(new Creature(this.width, this.height));

    // Keep food at minimum amount.
    while (this.food.size() < this.numFood)
      this.food.add(new FoodPellet(this.width, this.height));
  }

  <T extends Positioned> void eat(Creature eater, T food) {
    eater.energy += food.getEnergyValue();
    if (food instanceof FoodPellet) this.food.remove(food);
    else this.population.remove(food);
  }
}
