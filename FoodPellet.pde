class FoodPellet implements Positioned {
  PVector pos;
  float foodValue;

  FoodPellet( PVector pos, float foodValue ) {
    this.pos = pos;
    this.foodValue = foodValue;
  }
  FoodPellet (int maxWidth, int maxHeight) {
    this.pos = new PVector (random(maxWidth), random(maxHeight));
    this.foodValue = 1;
  }

  public PVector getPosition() {
    return this.pos;
  }

  public float getRadius() {
    return this.foodValue;
  }

  public float getEnergyValue() {
    return this.foodValue;
  }
}
