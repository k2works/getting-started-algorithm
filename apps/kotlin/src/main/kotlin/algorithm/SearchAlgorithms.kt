package algorithm

object SearchAlgorithms {
    fun linearSearchWhile(a: IntArray, key: Int): Int {
        var index = 0
        while (index < a.size) {
            if (a[index] == key) return index
            index++
        }
        return -1
    }

    fun linearSearchFor(a: IntArray, key: Int): Int {
        for (index in a.indices) {
            if (a[index] == key) return index
        }
        return -1
    }

    fun linearSearchSentinel(a: IntArray, key: Int): Int {
        val copy = a.copyOf(a.size + 1)
        copy[a.size] = key

        var index = 0
        while (copy[index] != key) index++
        return if (index == a.size) -1 else index
    }

    fun binarySearch(a: IntArray, key: Int): Int {
        var left = 0
        var right = a.lastIndex
        while (left <= right) {
            val middle = left + (right - left) / 2
            when {
                a[middle] == key -> return middle
                a[middle] < key -> left = middle + 1
                else -> right = middle - 1
            }
        }
        return -1
    }

    class ChainedHash(capacity: Int) {
        private class Node(
            val key: Int,
            val value: String,
            var next: Node?,
        )

        private val table: Array<Node?>

        init {
            require(capacity > 0) { "容量は 1 以上でなければなりません。" }
            table = arrayOfNulls(capacity)
        }

        fun search(key: Int): String? {
            var node = table[hashValue(key)]
            while (node != null) {
                if (node.key == key) return node.value
                node = node.next
            }
            return null
        }

        fun add(key: Int, value: String): Boolean {
            val bucket = hashValue(key)
            var node = table[bucket]
            while (node != null) {
                if (node.key == key) return false
                node = node.next
            }
            table[bucket] = Node(key, value, table[bucket])
            return true
        }

        fun remove(key: Int): Boolean {
            val bucket = hashValue(key)
            var previous: Node? = null
            var node = table[bucket]
            while (node != null) {
                if (node.key == key) {
                    if (previous == null) {
                        table[bucket] = node.next
                    } else {
                        previous.next = node.next
                    }
                    return true
                }
                previous = node
                node = node.next
            }
            return false
        }

        private fun hashValue(key: Int): Int = Math.floorMod(key, table.size)
    }

    class OpenHash(capacity: Int) {
        private enum class Status { EMPTY, OCCUPIED, DELETED }

        private class Bucket {
            var key: Int? = null
            var value: String? = null
            var status = Status.EMPTY
        }

        private val table: Array<Bucket>

        init {
            require(capacity > 0) { "容量は 1 以上でなければなりません。" }
            table = Array(capacity) { Bucket() }
        }

        fun search(key: Int): String? {
            var index = hashValue(key)
            repeat(table.size) {
                val bucket = table[index]
                when (bucket.status) {
                    Status.EMPTY -> return null
                    Status.OCCUPIED -> if (bucket.key == key) return bucket.value
                    Status.DELETED -> Unit
                }
                index = nextIndex(index)
            }
            return null
        }

        fun add(key: Int, value: String): Boolean {
            var index = hashValue(key)
            var firstDeleted = -1
            repeat(table.size) {
                val bucket = table[index]
                when (bucket.status) {
                    Status.EMPTY -> {
                        val destination = if (firstDeleted >= 0) firstDeleted else index
                        occupy(destination, key, value)
                        return true
                    }
                    Status.OCCUPIED -> if (bucket.key == key) return false
                    Status.DELETED -> if (firstDeleted < 0) firstDeleted = index
                }
                index = nextIndex(index)
            }

            if (firstDeleted >= 0) {
                occupy(firstDeleted, key, value)
                return true
            }
            return false
        }

        fun remove(key: Int): Boolean {
            var index = hashValue(key)
            repeat(table.size) {
                val bucket = table[index]
                when (bucket.status) {
                    Status.EMPTY -> return false
                    Status.OCCUPIED -> if (bucket.key == key) {
                        bucket.key = null
                        bucket.value = null
                        bucket.status = Status.DELETED
                        return true
                    }
                    Status.DELETED -> Unit
                }
                index = nextIndex(index)
            }
            return false
        }

        private fun occupy(index: Int, key: Int, value: String) {
            val bucket = table[index]
            bucket.key = key
            bucket.value = value
            bucket.status = Status.OCCUPIED
        }

        private fun hashValue(key: Int): Int = Math.floorMod(key, table.size)

        private fun nextIndex(index: Int): Int = (index + 1) % table.size
    }
}
