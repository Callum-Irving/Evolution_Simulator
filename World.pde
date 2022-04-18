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
    // Update each creature
    // Create new creature babies
    // If creatures died, create new ones
    // Replenish food supply
  }
}
