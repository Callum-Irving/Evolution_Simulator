class MutableColor {
  int r, g, b;
  
  public MutableColor(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  public MutableColor(MutableColor initial) {
    this.r = initial.r + (int)(randomGaussian() * 5);
    this.g = initial.g + (int)(randomGaussian() * 5);
    this.b = initial.b + (int)(randomGaussian() * 5);
  }
  
  public color getColor() {
    return color(this.r, this.g, this.b);
  }
}
