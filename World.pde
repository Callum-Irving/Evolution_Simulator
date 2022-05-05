boolean PREDATION = true;

class World {
  int width, height;
  ArrayList<FoodPellet> food;
  ArrayList<Creature> population;

  World(int width, int height, int numFood, int populationSize) {
    this.width = width;
    this.height = height;
    this.food = new ArrayList<FoodPellet>(numFood);
    this.population = new ArrayList<Creature>(populationSize);

    // Initialize population
    for (int i = 0; i < populationSize; i++)
      this.population.add(new Creature(width, height));

    // Create food pellets
    for (int i = 0; i < numFood; i++)
      this.food.add(new FoodPellet(width, height));
  }
  
  synchronized void resetPopulation() {
    this.population.clear();
  }

  synchronized void update() {
    ArrayList<Creature> babies = new ArrayList<Creature>();

    // Update each creature
    for (Creature c : this.population) {
      Positioned nearest = this.nearestNeighbour(c);
      boolean ateFood = c.update(this.population.size() + babies.size(), babies, nearest, this.width, this.height);
      if (ateFood) nearest.getEaten();
      c.show();
    }

    for (FoodPellet food : this.food)
      food.show();

    // Remove dead creatures.
    for (int i = this.population.size() - 1; i >= 0; i--)
      if (this.population.get(i).eaten())
        this.population.remove(i);
    
    this.population.addAll(babies);

    // Remove eaten food.
    for (int i = this.food.size() - 1; i >= 0; i--)
      if (this.food.get(i).eaten()) this.food.remove(i);

    // Keep population at minimum amount.
    while (this.population.size() < MIN_CREATURES)
      this.population.add(new Creature(this.width, this.height));

    // Keep food at minimum amount.
    while (this.food.size() < NUM_FOOD)
      this.food.add(new FoodPellet(this.width, this.height));
  }

  // Returns the closest creature or food pellet to c.
  Positioned nearestNeighbour(Creature c) {
    Positioned best = null;
    float bestDist = Float.MAX_VALUE;

    // Only check other creatures if predation is enabled.
    if (PREDATION) {
      for (Creature other : this.population) {
        if (other == c) continue;
        PVector diff = PVector.sub(other.getPosition(), c.getPosition());
        float dist = diff.dot(diff);
        if (dist < bestDist) {
          bestDist = dist;
          best = other;
        }
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
