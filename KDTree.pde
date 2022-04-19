interface Positioned {
  public PVector getPosition();

  public float getRadius();

  public float getEnergyValue();
}

// KD Tree for 2 dimensions.
class KDTree<T extends Positioned> {
  KDNode root = null;

  // Insert all items into the kd tree.
  public void insertList(ArrayList<T> items) {
    for (T item : items) {
      this.insertItem(item);
    }
  }

  public void insertItem(T item) {
    // Horizontal = true, vertical = false
    boolean horizontal = true;
    KDNode current = this.root;
    while (current != null) {
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
    }
    current = new KDNode(item);
  }

  public void remove(T item) {
    // Search for item using item.pos then remove it
  }

  public T nthNearest(int n, T item) {
    return item;
  }
}

class KDNode<T extends Positioned> {
  T item;
  KDNode left = null;
  KDNode right = null;

  public KDNode(T item) {
    this.item = item;
  }

  public PVector getPosition() {
    return this.item.getPosition();
  }
}
