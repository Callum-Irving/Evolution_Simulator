interface Positioned {
  public PVector getPosition();

  public float getRadius();

  public float getEnergyValue();
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

  // Remove an item from the tree.
  public void remove(Positioned item) {
    // Search for item using item.pos then remove it
    KDNode itemNode = this.root;
    boolean horizontal = true;
    while (itemNode.item != item && itemNode != null) {
      if (horizontal) {
        if (item.getPosition().x < itemNode.getPosition().x)
          itemNode = itemNode.left;
        else
          itemNode = itemNode.right;
      } else {
        if (item.getPosition().y < itemNode.getPosition().y)
          itemNode = itemNode.left;
        else
          itemNode = itemNode.right;
      }
    }

    // If item is not in tree, return.
    if (itemNode == null) return;

    // If it's a leaf node, just delete it.
    if (itemNode.left == null && itemNode.right == null) {
      if (itemNode.parent.left == itemNode) itemNode.parent.left = null;
      else itemNode.parent.right = null;
      return;
    }

    // If has right subtree, replace with minimum from right tree
    if (itemNode.right != null) {
      KDNode replacement = minChild(itemNode.right, horizontal);
      // We need to remove the replacement nodes parent branch.
      if (replacement.parent.left == replacement) replacement.parent.left = null;
      else replacement.parent.right = null;

      // This effectively replaces the node because the parent and children nodes
      // stay the same.
      itemNode.item = replacement.item;
      return;
    }

    // If no right subtree, swap subtrees then replace with minimum from right tree
    KDNode temp = itemNode.left;
    itemNode.left = itemNode.right;
    itemNode.right = temp;
    KDNode replacement = minChild(itemNode.right, horizontal);
    if (replacement.parent.left == replacement) replacement.parent.left = null;
    else replacement.parent.right = null;
    itemNode.item = replacement.item;
  }

  // Return the nth nearest neighbour to item.
  public Positioned nthNearest(int n, Positioned item) {
    return item;
  }

  private KDNode minChild(KDNode node, boolean horizontal) {
    // Return right first
    return this.root;
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
