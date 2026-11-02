mod StackQueue {
    ///
    /// Returns true if the stack contains no values.
    ///
    pub def stackIsEmpty(size: Int32): Bool =
        size <= 0

    ///
    /// Returns true if the stack has reached the array capacity.
    ///
    pub def stackIsFull(size: Int32, values: Array[a, r]): Bool =
        size >= Array.length(values)

    ///
    /// Pushes a value and returns the new stack size, or None if full.
    ///
    pub def stackPush(value: a, values: Array[a, r], size: Int32): Option[Int32] \ r =
        let capacity = Array.length(values);
        if (size < 0 or size >= capacity) {
            None
        } else {
            Array.put(value, size, values);
            Some(size + 1)
        }

    ///
    /// Pops a value and returns it with the new stack size.
    ///
    pub def stackPop(values: Array[a, r], size: Int32): Option[(a, Int32)] \ r =
        if (size <= 0 or size > Array.length(values)) {
            None
        } else {
            let newSize = size - 1;
            Some((Array.get(newSize, values), newSize))
        }

    ///
    /// Returns the top value without changing the stack.
    ///
    pub def stackPeek(values: Array[a, r], size: Int32): Option[a] \ r =
        if (size <= 0 or size > Array.length(values))
            None
        else
            Some(Array.get(size - 1, values))

    ///
    /// Returns true if the queue contains no values.
    ///
    pub def queueIsEmpty(size: Int32): Bool =
        size <= 0

    ///
    /// Returns true if the queue has reached the array capacity.
    ///
    pub def queueIsFull(size: Int32, values: Array[a, r]): Bool =
        size >= Array.length(values)

    ///
    /// Enqueues a value and returns the new rear and size, or None if full.
    ///
    pub def queueEnqueue(
        value: a,
        values: Array[a, r],
        rear: Int32,
        size: Int32
    ): Option[(Int32, Int32)] \ r =
        let capacity = Array.length(values);
        if (capacity <= 0 or rear < 0 or rear >= capacity or size < 0 or size >= capacity) {
            None
        } else {
            Array.put(value, rear, values);
            let newRear = if (rear + 1 == capacity) 0 else rear + 1;
            Some((newRear, size + 1))
        }

    ///
    /// Dequeues a value and returns it with the new front and size.
    ///
    pub def queueDequeue(
        values: Array[a, r],
        front: Int32,
        size: Int32
    ): Option[(a, Int32, Int32)] \ r =
        let capacity = Array.length(values);
        if (capacity <= 0 or front < 0 or front >= capacity or size <= 0 or size > capacity) {
            None
        } else {
            let value = Array.get(front, values);
            let newFront = if (front + 1 == capacity) 0 else front + 1;
            Some((value, newFront, size - 1))
        }

    ///
    /// Returns the front value without changing the queue.
    ///
    pub def queuePeek(values: Array[a, r], front: Int32, size: Int32): Option[a] \ r =
        let capacity = Array.length(values);
        if (capacity <= 0 or front < 0 or front >= capacity or size <= 0 or size > capacity)
            None
        else
            Some(Array.get(front, values))
}
