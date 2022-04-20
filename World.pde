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
    //KDTree tree = new KDTree();
    //tree.insertList(this.population);
    //tree.insertList(this.food);

    // Update each creature
    for (Creature c : this.population) {
      //Positioned nearest = tree.nearestNeighbour(c);
      //Positioned nearest = tree.findNearest(c);
      Positioned nearest = this.badNN(c);
      boolean ateFood = c.step(nearest, this.width, this.height);
      if (ateFood) nearest.getEaten();
      c.show();
    }
    
    for (FoodPellet food : this.food)
      food.show();

    // Remove dead creatures.
    for (int i = this.population.size() - 1; i >= 0; i--)
      if (this.population.get(i).eaten()) this.population.remove(i);

    // Remove eaten food.
    for (int i = this.food.size() - 1; i >= 0; i--)
      if (this.food.get(i).eaten()) this.food.remove(i);

    // Keep population at minimum amount.
    while (this.population.size() < this.minPopulation)
      this.population.add(new Creature(this.width, this.height));

    // Keep food at minimum amount.
    while (this.food.size() < this.numFood)
      this.food.add(new FoodPellet(this.width, this.height));
  }

  Positioned badNN(Creature c) {
    Positioned best = null;
    float bestDist = Float.MAX_VALUE;
    for (Creature other : this.population) {
      if (c == other) continue;
      PVector diff = PVector.sub(other.getPosition(), c.getPosition());
      float dist = diff.dot(diff);
      if (dist < bestDist) {
        bestDist = dist;
        best = c;
      }
    }

    for (FoodPellet food : this.food) {
      PVector diff = PVector.sub(food.getPosition(), c.getPosition());
      float dist = diff.dot(diff);
      if (dist <= bestDist) {
        bestDist = dist;
        best = food;
      }
    }

    return best;
  }
}
