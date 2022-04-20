interface Positioned {
  public PVector getPosition();

  public float getRadius();

  public float getEnergyValue();

  public boolean eaten();

  public void getEaten();
}

// KD Tree for 2 dimensions.
class KDTree {
  KDNode root = null;

  // Insert all items into the kd tree.
  public void insertList(ArrayList<? extends Positioned> items) {
    for (Positioned item : items) {
      this.insertItem(item);
    }
  }

  // IMPORTANT: Equal position goes on the right
  public void insertItem(Positioned item) {
    boolean horizontal = true;
    KDNode parent = this.root;
    KDNode current = this.root;
    while (current != null) {
      parent = current;
      if (horizontal) {
        if (item.getPosition().x < current.getPosition().x)
          current = current.left;
        else
          current = current.right;
      } else {
        if (item.getPosition().y < current.getPosition().y)
          current = current.left;
        else
          current = current.right;
      }
      horizontal = !horizontal;
    }
    current = new KDNode(item);
    current.parent = parent;
  }

  // TODO: Find best and second best so that if best is the node
  // we can use the second best;

  // Return the nth nearest neighbour to item.
  // TODO
  public Positioned nearestNeighbour(Positioned item) {
    KDNode best = this.initialBest(item);
    KDNode secondBest = this.initialBest(item);
    if (best.item == item) best = secondBest;
    return best.item;
  }

  // Find the closest leaf node.
  private KDNode initialBest(Positioned item) {
    // While we are not at a leaf node;
    KDNode current = this.root;
    boolean horizontal = true;
    while (current.left != null || current.right != null) {
      if (horizontal) {
        if (current.getPosition().x < item.getPosition().x)
          current = current.left;
        else
          current = current.right;
      } else {
        if (current.getPosition().y < item.getPosition().y)
          current = current.left;
        else
          current = current.right;
      }
    }
    return current;
  }

  private Positioned q;
  private KDNode nearest;
  private float nearestDist;

  public Positioned findNearest(Positioned item) {
    this.q = item;
    this.nearestDist = Float.MAX_VALUE;
    this.NN(this.root, true);
    return this.nearest.item;
  }

  private void NN(KDNode t, boolean horizontal) {
    if (t == null) return;

    boolean comp = horizontal ? this.q.getPosition().x < t.getPosition().x : this.q.getPosition().y < t.getPosition().y;
    if (comp) {
      this.NN(t.left, !horizontal);
      this.NN(t.right, !horizontal);
    } else {
      this.NN(t.right, !horizontal);
      this.NN(t.left, !horizontal);
    }

    PVector diff = PVector.sub(t.getPosition(), this.q.getPosition());
    float dist = diff.dot(diff);
    if (t.item != q && dist < this.nearestDist) {
      this.nearest = t;
      this.nearestDist = dist;
    }
  }
}

class KDNode {
  Positioned item;
  KDNode parent = null;
  KDNode left = null;
  KDNode right = null;

  public KDNode(Positioned item) {
    this.item = item;
  }

  public PVector getPosition() {
    return this.item.getPosition();
  }
}
