class FoodPellet implements Positioned {
  PVector pos;
  float foodValue;
  boolean eaten = false;

  FoodPellet( PVector pos, float foodValue ) {
    this.pos = pos;
    this.foodValue = foodValue;
  }
  FoodPellet (int maxWidth, int maxHeight) {
    this.pos = new PVector (random(maxWidth), random(maxHeight));
    this.foodValue = 10;
  }

  public void show() {
    fill(0, 255, 0);
    circle(this.pos.x, this.pos.y, this.foodValue * 2);
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

  public boolean eaten() {
    return this.eaten;
  }

  public void getEaten() {
    this.eaten = true;
  }
}
