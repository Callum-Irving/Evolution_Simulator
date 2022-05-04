import processing.core.*;
import java.util.Deque;
import java.util.ArrayDeque;

class GraphApplet extends PApplet {
  private float scaleX;
  private float scaleY;

  private int numPoints;
  private int numIterations = 0;
  private Deque<Float> points;

  public GraphApplet(float scaleX, float scaleY, int points) {
    this.scaleX = scaleX;
    this.scaleY = scaleY;
    this.numPoints = points;
    this.points = new ArrayDeque<Float>(points);
  }

  synchronized public void addPoint(float point) {
    this.points.addLast(point);
    if (this.points.size() > this.numPoints) this.points.removeFirst();
    this.numIterations++;
  }

  public void settings() {
    this.size(400, 400);
  }

  synchronized public void draw() {
    this.background(255);
    this.noStroke();
    this.fill(255, 0, 0);
    //scale(scaleX, scaleY);
    int i = 0;
    for (Float point : this.points) {
      this.circle(i * 4, this.height - (point), 4);
      i++;
    }
    this.circle(200, 200, 40);
  }
}
