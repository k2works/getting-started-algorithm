package algorithm

class SinglyLinkedList<T : Any> {
    private class Node<T>(val value: T, var next: Node<T>? = null)

    private var head: Node<T>? = null
    private var tail: Node<T>? = null

    var size: Int = 0
        private set

    fun isEmpty(): Boolean = size == 0

    fun addFirst(value: T) {
        val node = Node(value, head)
        head = node
        if (tail == null) tail = node
        size++
    }

    fun addLast(value: T) {
        val node = Node(value)
        val last = tail
        if (last == null) {
            head = node
        } else {
            last.next = node
        }
        tail = node
        size++
    }

    fun removeFirst(): T? {
        val first = head ?: return null
        head = first.next
        if (head == null) tail = null
        size--
        return first.value
    }

    fun removeLast(): T? {
        val last = tail ?: return null
        if (head === last) {
            head = null
            tail = null
        } else {
            var previous = checkNotNull(head)
            while (previous.next !== last) {
                previous = checkNotNull(previous.next)
            }
            previous.next = null
            tail = previous
        }
        size--
        return last.value
    }

    fun remove(value: T): Boolean {
        var previous: Node<T>? = null
        var current = head
        while (current != null) {
            if (current.value == value) {
                if (previous == null) {
                    removeFirst()
                } else {
                    previous.next = current.next
                    if (tail === current) tail = previous
                    size--
                }
                return true
            }
            previous = current
            current = current.next
        }
        return false
    }

    fun contains(value: T): Boolean {
        var current = head
        while (current != null) {
            if (current.value == value) return true
            current = current.next
        }
        return false
    }

    fun toList(): List<T> {
        val values = ArrayList<T>(size)
        var current = head
        while (current != null) {
            values.add(current.value)
            current = current.next
        }
        return values
    }
}

class DoublyLinkedList<T : Any> {
    private class Node<T : Any>(var value: T?) {
        lateinit var previous: Node<T>
        lateinit var next: Node<T>
    }

    private val sentinel = Node<T>(null).also {
        it.previous = it
        it.next = it
    }

    var size: Int = 0
        private set

    fun isEmpty(): Boolean = size == 0

    fun addFirst(value: T) = insertBetween(value, sentinel, sentinel.next)

    fun addLast(value: T) = insertBetween(value, sentinel.previous, sentinel)

    fun removeFirst(): T? = if (isEmpty()) null else unlink(sentinel.next)

    fun removeLast(): T? = if (isEmpty()) null else unlink(sentinel.previous)

    fun remove(value: T): Boolean {
        var current = sentinel.next
        while (current !== sentinel) {
            if (current.value == value) {
                unlink(current)
                return true
            }
            current = current.next
        }
        return false
    }

    fun contains(value: T): Boolean {
        var current = sentinel.next
        while (current !== sentinel) {
            if (current.value == value) return true
            current = current.next
        }
        return false
    }

    fun toList(): List<T> {
        val values = ArrayList<T>(size)
        var current = sentinel.next
        while (current !== sentinel) {
            values.add(checkNotNull(current.value))
            current = current.next
        }
        return values
    }

    fun reversed(): List<T> {
        val values = ArrayList<T>(size)
        var current = sentinel.previous
        while (current !== sentinel) {
            values.add(checkNotNull(current.value))
            current = current.previous
        }
        return values
    }

    private fun insertBetween(value: T, previous: Node<T>, next: Node<T>) {
        val node = Node(value)
        node.previous = previous
        node.next = next
        previous.next = node
        next.previous = node
        size++
    }

    private fun unlink(node: Node<T>): T {
        val value = checkNotNull(node.value)
        node.previous.next = node.next
        node.next.previous = node.previous
        node.previous = node
        node.next = node
        node.value = null
        size--
        return value
    }
}
