package algorithm

class FixedStack<T : Any>(val capacity: Int) {
    private val elements: Array<Any?>
    private var pointer = 0

    init {
        require(capacity > 0) { "容量は 1 以上でなければなりません。" }
        elements = arrayOfNulls(capacity)
    }

    val size: Int
        get() = pointer

    fun isEmpty(): Boolean = pointer == 0

    fun isFull(): Boolean = pointer == capacity

    fun push(value: T) {
        check(!isFull()) { "スタックは満杯です。" }
        elements[pointer++] = value
    }

    @Suppress("UNCHECKED_CAST")
    fun pop(): T {
        check(!isEmpty()) { "スタックは空です。" }
        val index = --pointer
        val value = elements[index]
        elements[index] = null
        return value as T
    }

    @Suppress("UNCHECKED_CAST")
    fun peek(): T {
        check(!isEmpty()) { "スタックは空です。" }
        return elements[pointer - 1] as T
    }

    fun find(value: T): Int {
        for (index in pointer - 1 downTo 0) {
            if (elements[index] == value) return index
        }
        return -1
    }

    fun count(value: T): Int {
        var matches = 0
        for (index in 0 until pointer) {
            if (elements[index] == value) matches++
        }
        return matches
    }

    fun contains(value: T): Boolean = find(value) >= 0

    fun clear() {
        elements.fill(null)
        pointer = 0
    }
}

class FixedQueue<T : Any>(val capacity: Int) {
    private val elements: Array<Any?>
    private var front = 0
    private var rear = 0
    private var count = 0

    init {
        require(capacity > 0) { "容量は 1 以上でなければなりません。" }
        elements = arrayOfNulls(capacity)
    }

    val size: Int
        get() = count

    fun isEmpty(): Boolean = count == 0

    fun isFull(): Boolean = count == capacity

    fun enque(value: T) {
        check(!isFull()) { "キューは満杯です。" }
        elements[rear] = value
        rear = nextIndex(rear)
        count++
    }

    @Suppress("UNCHECKED_CAST")
    fun deque(): T {
        check(!isEmpty()) { "キューは空です。" }
        val value = elements[front]
        elements[front] = null
        front = nextIndex(front)
        count--
        return value as T
    }

    @Suppress("UNCHECKED_CAST")
    fun peek(): T {
        check(!isEmpty()) { "キューは空です。" }
        return elements[front] as T
    }

    fun find(value: T): Int {
        for (offset in 0 until count) {
            if (elements[indexAt(offset)] == value) return offset
        }
        return -1
    }

    fun count(value: T): Int {
        var matches = 0
        for (offset in 0 until count) {
            if (elements[indexAt(offset)] == value) matches++
        }
        return matches
    }

    fun contains(value: T): Boolean = find(value) >= 0

    fun clear() {
        elements.fill(null)
        front = 0
        rear = 0
        count = 0
    }

    private fun indexAt(offset: Int): Int = (front + offset) % capacity

    private fun nextIndex(index: Int): Int = (index + 1) % capacity
}
