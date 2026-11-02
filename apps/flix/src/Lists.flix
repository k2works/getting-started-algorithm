mod Lists {
    ///
    /// An immutable singly linked list node.
    ///
    pub enum Chain[a] {
        case ChainEmpty
        case ChainNode(a, Chain[a])
    }

    ///
    /// Returns the input standard list unchanged.
    ///
    pub def fromList(values: List[a]): List[a] =
        values

    ///
    /// Prepends a value to the standard immutable list.
    ///
    pub def prepend(value: a, values: List[a]): List[a] =
        value :: values

    ///
    /// Appends a value to the standard immutable list.
    ///
    pub def append(value: a, values: List[a]): List[a] = match values {
        case Nil => value :: Nil
        case head :: tail => head :: append(value, tail)
    }

    ///
    /// Returns the number of elements in the list.
    ///
    pub def length(values: List[a]): Int32 = match values {
        case Nil => 0
        case _ :: tail => 1 + length(tail)
    }

    ///
    /// Returns the list unchanged, for examples and assertions.
    ///
    pub def toList(values: List[a]): List[a] =
        values

    ///
    /// Constructs the custom linked-list ADT from a standard list.
    ///
    pub def chainFromList(values: List[a]): Chain[a] = match values {
        case Nil => Chain.ChainEmpty
        case head :: tail => Chain.ChainNode(head, chainFromList(tail))
    }

    ///
    /// Converts the custom linked-list ADT to a standard list.
    ///
    pub def chainToList(values: Chain[a]): List[a] = match values {
        case Chain.ChainEmpty => Nil
        case Chain.ChainNode(value, tail) => value :: chainToList(tail)
    }

    ///
    /// Returns the first index containing the requested value.
    ///
    pub def chainSearch(value: a, values: Chain[a]): Option[Int32] with Eq[a] =
        def loop(index, xs) = match xs {
            case Chain.ChainEmpty => None
            case Chain.ChainNode(head, tail) =>
                if (head == value) Some(index) else loop(index + 1, tail)
        };
        loop(0, values)

    ///
    /// Removes and returns the first value, if present.
    ///
    pub def chainRemoveFirst(values: Chain[a]): Option[(a, Chain[a])] = match values {
        case Chain.ChainEmpty => None
        case Chain.ChainNode(value, tail) => Some((value, tail))
    }

    ///
    /// Creates a cursor-based list store and a free-list chain.
    ///
    pub def cursorCreate(rc: Region[r], capacity: Int32): (Array[Int32, r], Array[Int32, r]) \ r =
        let size = if (capacity < 0) 0 else capacity;
        let values = Array.repeat(rc, size, 0);
        let links = Array.init(rc, i -> if (i + 1 < size) i + 1 else -1, size);
        (values, links)

    ///
    /// Inserts at the head using the first free cursor.
    ///
    pub def cursorInsertFirst(
        value: Int32,
        values: Array[Int32, r],
        links: Array[Int32, r],
        head: Int32,
        free: Int32,
        size: Int32
    ): Option[(Int32, Int32, Int32)] \ r =
        let capacity = Array.length(values);
        if (
            Array.length(links) != capacity or
            size < 0 or size >= capacity or
            head < -1 or head >= capacity or
            free < 0 or free >= capacity
        ) {
            None
        } else {
            let nextFree = Array.get(free, links);
            if (nextFree < -1 or nextFree >= capacity) {
                None
            } else {
                Array.put(value, free, values);
                Array.put(head, free, links);
                Some((free, nextFree, size + 1))
            }
        }

    ///
    /// Removes the head and returns its cursor to the free-list chain.
    ///
    pub def cursorRemoveFirst(
        values: Array[Int32, r],
        links: Array[Int32, r],
        head: Int32,
        free: Int32,
        size: Int32
    ): Option[(Int32, Int32, Int32, Int32)] \ r =
        let capacity = Array.length(values);
        if (
            Array.length(links) != capacity or
            size <= 0 or size > capacity or
            head < 0 or head >= capacity or
            free < -1 or free >= capacity
        ) {
            None
        } else {
            let nextHead = Array.get(head, links);
            if (nextHead < -1 or nextHead >= capacity) {
                None
            } else {
                let value = Array.get(head, values);
                Array.put(free, head, links);
                Some((value, nextHead, head, size - 1))
            }
        }

    ///
    /// Traverses the cursor list if its links and declared size are consistent.
    ///
    pub def cursorToList(
        values: Array[Int32, r],
        links: Array[Int32, r],
        head: Int32,
        size: Int32
    ): Option[List[Int32]] \ r =
        let capacity = Array.length(values);
        if (Array.length(links) != capacity or size < 0 or size > capacity) {
            None
        } else {
            def loop(cursor, remaining) =
                if (remaining == 0) {
                    if (cursor == -1) Some(Nil) else None
                } else if (cursor < 0 or cursor >= capacity) {
                    None
                } else {
                    match loop(Array.get(cursor, links), remaining - 1) {
                        case None => None
                        case Some(rest) => Some(Array.get(cursor, values) :: rest)
                    }
                };
            loop(head, size)
        }

    ///
    /// Moves a list zipper focus one element to the right.
    ///
    pub def zipperMoveNext(zipper: (List[a], List[a])): Option[(List[a], List[a])] =
        let (left, right) = zipper;
        match right {
            case Nil => None
            case value :: rest => Some((value :: left, rest))
        }

    ///
    /// Moves a list zipper focus one element to the left.
    ///
    pub def zipperMovePrevious(zipper: (List[a], List[a])): Option[(List[a], List[a])] =
        let (left, right) = zipper;
        match left {
            case Nil => None
            case value :: rest => Some((rest, value :: right))
        }

    ///
    /// Inserts a value at the zipper focus.
    ///
    pub def zipperInsert(value: a, zipper: (List[a], List[a])): (List[a], List[a]) =
        let (left, right) = zipper;
        (left, value :: right)

    ///
    /// Removes and returns the value at the zipper focus.
    ///
    pub def zipperRemove(zipper: (List[a], List[a])): Option[(a, (List[a], List[a]))] =
        let (left, right) = zipper;
        match right {
            case Nil => None
            case value :: rest => Some((value, (left, rest)))
        }

    ///
    /// Returns the zipper contents in their original order.
    ///
    pub def zipperToList(zipper: (List[a], List[a])): List[a] =
        let (left, right) = zipper;
        def reverse(xs, acc) = match xs {
            case Nil => acc
            case head :: tail => reverse(tail, head :: acc)
        };
        def concat(xs, ys) = match xs {
            case Nil => ys
            case head :: tail => head :: concat(tail, ys)
        };
        concat(reverse(left, Nil), right)

    ///
    /// Rotates a non-empty list left by one position.
    ///
    pub def rotateLeft(values: List[a]): List[a] = match values {
        case Nil => Nil
        case head :: tail =>
            def appendLast(xs) = match xs {
                case Nil => head :: Nil
                case value :: rest => value :: appendLast(rest)
            };
            appendLast(tail)
    }
}
