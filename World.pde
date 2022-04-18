class World {
  int width, height;
  ArrayList<FoodPellet> food;
  ArrayList<Creature> population;

  int numFood;

  World(int width, int height, int numFood, int populationSize) {
    this.width = width;
    this.height = height;
    this.numFood = numFood;
    this.food = new ArrayList<FoodPellet>(numFood);
    this.population = new ArrayList<Creature>(populationSize);

    // intionalizing the population
    for (int i = 0; i < populationSize; i++)
      this.population.add(new Creature(width, height));

    // creating the food
    for (int i = 0; i < numFood; i++)
      this.food.add(new FoodPellet(width, height));
  }

  void step() {
  }
}
