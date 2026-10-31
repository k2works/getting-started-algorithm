package algorithm

class BinarySearchTree<K : Comparable<K>, V : Any> {
    private sealed class Node<K : Comparable<K>, V : Any> {
        class Empty<K : Comparable<K>, V : Any> : Node<K, V>()

        class Branch<K : Comparable<K>, V : Any>(
            var key: K,
            var value: V,
            var left: Node<K, V> = Empty(),
            var right: Node<K, V> = Empty(),
        ) : Node<K, V>()
    }

    private var root: Node<K, V> = Node.Empty()

    var size: Int = 0
        private set

    fun isEmpty(): Boolean = size == 0

    fun add(key: K, value: V): Boolean {
        val (updatedRoot, added) = insert(root, key, value)
        root = updatedRoot
        if (added) size++
        return added
    }

    fun search(key: K): V? {
        var current = root
        while (current is Node.Branch) {
            val comparison = key.compareTo(current.key)
            when {
                comparison == 0 -> return current.value
                comparison < 0 -> current = current.left
                else -> current = current.right
            }
        }
        return null
    }

    fun remove(key: K): Boolean {
        val (updatedRoot, removed) = remove(root, key)
        root = updatedRoot
        if (removed) size--
        return removed
    }

    fun inorder(): List<Pair<K, V>> = buildList { appendInorder(root, this) }

    fun preorder(): List<Pair<K, V>> = buildList { appendPreorder(root, this) }

    fun postorder(): List<Pair<K, V>> = buildList { appendPostorder(root, this) }

    fun minKey(): K? {
        var current = root
        while (current is Node.Branch && current.left is Node.Branch) {
            current = current.left
        }
        return (current as? Node.Branch)?.key
    }

    fun maxKey(): K? {
        var current = root
        while (current is Node.Branch && current.right is Node.Branch) {
            current = current.right
        }
        return (current as? Node.Branch)?.key
    }

    private fun insert(node: Node<K, V>, key: K, value: V): Pair<Node<K, V>, Boolean> =
        when (node) {
            is Node.Empty -> Node.Branch(key, value) to true
            is Node.Branch -> {
                val comparison = key.compareTo(node.key)
                when {
                    comparison == 0 -> node to false
                    comparison < 0 -> {
                        val (left, added) = insert(node.left, key, value)
                        node.left = left
                        node to added
                    }
                    else -> {
                        val (right, added) = insert(node.right, key, value)
                        node.right = right
                        node to added
                    }
                }
            }
        }

    private fun remove(node: Node<K, V>, key: K): Pair<Node<K, V>, Boolean> =
        when (node) {
            is Node.Empty -> node to false
            is Node.Branch -> {
                val comparison = key.compareTo(node.key)
                when {
                    comparison < 0 -> {
                        val (left, removed) = remove(node.left, key)
                        node.left = left
                        node to removed
                    }
                    comparison > 0 -> {
                        val (right, removed) = remove(node.right, key)
                        node.right = right
                        node to removed
                    }
                    node.left is Node.Empty -> node.right to true
                    node.right is Node.Empty -> node.left to true
                    else -> {
                        val successor = minimum(node.right)
                        node.key = successor.key
                        node.value = successor.value
                        val (right, _) = remove(node.right, successor.key)
                        node.right = right
                        node to true
                    }
                }
            }
        }

    private fun minimum(node: Node<K, V>): Node.Branch<K, V> {
        var current = node
        while (current is Node.Branch && current.left is Node.Branch) {
            current = current.left
        }
        return current as Node.Branch
    }

    private fun appendInorder(node: Node<K, V>, result: MutableList<Pair<K, V>>) {
        when (node) {
            is Node.Empty -> Unit
            is Node.Branch -> {
                appendInorder(node.left, result)
                result.add(node.key to node.value)
                appendInorder(node.right, result)
            }
        }
    }

    private fun appendPreorder(node: Node<K, V>, result: MutableList<Pair<K, V>>) {
        when (node) {
            is Node.Empty -> Unit
            is Node.Branch -> {
                result.add(node.key to node.value)
                appendPreorder(node.left, result)
                appendPreorder(node.right, result)
            }
        }
    }

    private fun appendPostorder(node: Node<K, V>, result: MutableList<Pair<K, V>>) {
        when (node) {
            is Node.Empty -> Unit
            is Node.Branch -> {
                appendPostorder(node.left, result)
                appendPostorder(node.right, result)
                result.add(node.key to node.value)
            }
        }
    }
}

class MinHeap<T : Comparable<T>> {
    private val elements = mutableListOf<T>()

    val size: Int
        get() = elements.size

    fun isEmpty(): Boolean = elements.isEmpty()

    fun peek(): T? = elements.firstOrNull()

    fun add(value: T) {
        elements.add(value)
        siftUp(elements.lastIndex)
    }

    fun removeMin(): T? {
        if (elements.isEmpty()) return null
        val minimum = elements[0]
        val last = elements.removeAt(elements.lastIndex)
        if (elements.isNotEmpty()) {
            elements[0] = last
            siftDown(0)
        }
        return minimum
    }

    private fun siftUp(startIndex: Int) {
        var child = startIndex
        while (child > 0) {
            val parent = (child - 1) / 2
            if (elements[parent] <= elements[child]) return
            swap(parent, child)
            child = parent
        }
    }

    private fun siftDown(startIndex: Int) {
        var parent = startIndex
        while (true) {
            val leftChild = parent * 2 + 1
            if (leftChild >= elements.size) return
            val rightChild = leftChild + 1
            val smallerChild = if (
                rightChild < elements.size && elements[rightChild] < elements[leftChild]
            ) {
                rightChild
            } else {
                leftChild
            }
            if (elements[parent] <= elements[smallerChild]) return
            swap(parent, smallerChild)
            parent = smallerChild
        }
    }

    private fun swap(first: Int, second: Int) {
        val temporary = elements[first]
        elements[first] = elements[second]
        elements[second] = temporary
    }
}
