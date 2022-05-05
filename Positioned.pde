// This interface is implemented for food and creature so that creatures
// can eat foor OR other creatures.
interface Positioned {
  public PVector getPosition();

  public float getRadius();

  public float getEnergyValue();

  public boolean eaten();

  public void getEaten();
}
