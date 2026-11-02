mod Trees {
    ///
    /// An immutable binary search tree with Int32 keys.
    ///
    pub enum BST[a] {
        case Empty
        case Node(Int32, a, BST[a], BST[a])
    }

    ///
    /// Creates an empty binary search tree.
    ///
    pub def empty(): BST[a] =
        BST.Empty

    ///
    /// Inserts a key-value pair unless the key already exists.
    ///
    pub def add(key: Int32, value: a, tree: BST[a]): (BST[a], Bool) = match tree {
        case BST.Empty => (BST.Node(key, value, BST.Empty, BST.Empty), true)
        case BST.Node(nodeKey, nodeValue, left, right) =>
            if (key == nodeKey) {
                (tree, false)
            } else if (key < nodeKey) {
                let (updatedLeft, inserted) = add(key, value, left);
                if (inserted)
                    (BST.Node(nodeKey, nodeValue, updatedLeft, right), true)
                else
                    (tree, false)
            } else {
                let (updatedRight, inserted) = add(key, value, right);
                if (inserted)
                    (BST.Node(nodeKey, nodeValue, left, updatedRight), true)
                else
                    (tree, false)
            }
    }

    ///
    /// Searches for a key and returns its associated value.
    ///
    pub def search(key: Int32, tree: BST[a]): Option[a] = match tree {
        case BST.Empty => None
        case BST.Node(nodeKey, value, left, right) =>
            if (key == nodeKey)
                Some(value)
            else if (key < nodeKey)
                search(key, left)
            else
                search(key, right)
    }

    ///
    /// Removes the maximum node from a non-empty subtree.
    ///
    def removeMax(tree: BST[a]): Option[(Int32, a, BST[a])] = match tree {
        case BST.Empty => None
        case BST.Node(key, value, left, BST.Empty) => Some((key, value, left))
        case BST.Node(key, value, left, right) =>
            match removeMax(right) {
                case None => None
                case Some((maxKey, maxValue, updatedRight)) =>
                    Some((maxKey, maxValue, BST.Node(key, value, left, updatedRight)))
            }
    }

    ///
    /// Removes a key and reports whether it was present.
    ///
    pub def remove(key: Int32, tree: BST[a]): (BST[a], Bool) = match tree {
        case BST.Empty => (BST.Empty, false)
        case BST.Node(nodeKey, value, left, right) =>
            if (key < nodeKey) {
                let (updatedLeft, removed) = remove(key, left);
                if (removed)
                    (BST.Node(nodeKey, value, updatedLeft, right), true)
                else
                    (tree, false)
            } else if (key > nodeKey) {
                let (updatedRight, removed) = remove(key, right);
                if (removed)
                    (BST.Node(nodeKey, value, left, updatedRight), true)
                else
                    (tree, false)
            } else {
                match (left, right) {
                    case (BST.Empty, _) => (right, true)
                    case (_, BST.Empty) => (left, true)
                    case _ =>
                        match removeMax(left) {
                            case None => (tree, false)
                            case Some((predecessorKey, predecessorValue, updatedLeft)) =>
                                (
                                    BST.Node(predecessorKey, predecessorValue, updatedLeft, right),
                                    true
                                )
                        }
                }
            }
    }

    ///
    /// Returns key-value pairs in ascending key order.
    ///
    pub def inorder(tree: BST[a]): List[(Int32, a)] =
        def loop(node, acc) = match node {
            case BST.Empty => acc
            case BST.Node(key, value, left, right) =>
                loop(left, (key, value) :: loop(right, acc))
        };
        loop(tree, Nil)

    ///
    /// Returns the smallest key in the tree.
    ///
    pub def minKey(tree: BST[a]): Option[Int32] = match tree {
        case BST.Empty => None
        case BST.Node(key, _, BST.Empty, _) => Some(key)
        case BST.Node(_, _, left, _) => minKey(left)
    }

    ///
    /// Returns the largest key in the tree.
    ///
    pub def maxKey(tree: BST[a]): Option[Int32] = match tree {
        case BST.Empty => None
        case BST.Node(key, _, _, BST.Empty) => Some(key)
        case BST.Node(_, _, _, right) => maxKey(right)
    }

    ///
    /// Creates an array for a bounded min-heap.
    ///
    pub def heapCreate(rc: Region[r], capacity: Int32): Array[Int32, r] \ r =
        let size = if (capacity < 0) 0 else capacity;
        Array.repeat(rc, size, 0)

    def heapBubbleUp(index: Int32, heap: Array[Int32, r]): Unit \ r =
        if (index <= 0) {
            ()
        } else {
            let parent = (index - 1) / 2;
            let childValue = Array.get(index, heap);
            let parentValue = Array.get(parent, heap);
            if (childValue < parentValue) {
                Array.put(parentValue, index, heap);
                Array.put(childValue, parent, heap);
                heapBubbleUp(parent, heap)
            } else {
                ()
            }
        }

    def heapSiftDown(index: Int32, size: Int32, heap: Array[Int32, r]): Unit \ r =
        let left = index * 2 + 1;
        if (left >= size) {
            ()
        } else {
            let right = left + 1;
            let smallest =
                if (right < size and Array.get(right, heap) < Array.get(left, heap))
                    right
                else
                    left;
            let currentValue = Array.get(index, heap);
            let smallestValue = Array.get(smallest, heap);
            if (smallestValue < currentValue) {
                Array.put(smallestValue, index, heap);
                Array.put(currentValue, smallest, heap);
                heapSiftDown(smallest, size, heap)
            } else {
                ()
            }
        }

    ///
    /// Inserts a value and returns the new size, or None when full or invalid.
    ///
    pub def heapInsert(value: Int32, heap: Array[Int32, r], size: Int32): Option[Int32] \ r =
        let capacity = Array.length(heap);
        if (size < 0 or size >= capacity) {
            None
        } else {
            Array.put(value, size, heap);
            heapBubbleUp(size, heap);
            Some(size + 1)
        }

    ///
    /// Removes the minimum value and returns it with the new size.
    ///
    pub def heapRemoveMin(
        heap: Array[Int32, r],
        size: Int32
    ): Option[(Int32, Int32)] \ r =
        let capacity = Array.length(heap);
        if (size <= 0 or size > capacity) {
            None
        } else {
            let minimum = Array.get(0, heap);
            let newSize = size - 1;
            if (newSize == 0) {
                Some((minimum, 0))
            } else {
                Array.put(Array.get(newSize, heap), 0, heap);
                heapSiftDown(0, newSize, heap);
                Some((minimum, newSize))
            }
        }
}
