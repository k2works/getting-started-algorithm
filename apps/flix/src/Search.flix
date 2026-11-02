mod Search {
    ///
    /// Returns the index of the first matching value.
    ///
    pub def linearSearch(values: Array[Int32, r], key: Int32): Option[Int32] \ r =
        let length = Array.length(values);
        def loop(i) =
            if (i >= length)
                None
            else if (Array.get(i, values) == key)
                Some(i)
            else
                loop(i + 1);
        loop(0)

    ///
    /// Searches by placing a temporary key after a copy of the input array.
    ///
    pub def sentinelSearch(values: Array[Int32, r], key: Int32): Option[Int32] \ r =
        let length = Array.length(values);
        region rc {
            let extended = Array.init(rc, i -> if (i == length) key else Array.get(i, values), length + 1);
            def loop(i) =
                if (Array.get(i, extended) == key)
                    if (i == length) None else Some(i)
                else
                    loop(i + 1);
            loop(0)
        }

    ///
    /// Returns the first matching index in an ascendingly sorted array.
    ///
    pub def binarySearch(values: Array[Int32, r], key: Int32): Option[Int32] \ r =
        let length = Array.length(values);
        def lowerBound(left, right) =
            if (left >= right)
                left
            else {
                let middle = left + (right - left) / 2;
                if (Array.get(middle, values) < key)
                    lowerBound(middle + 1, right)
                else
                    lowerBound(left, middle)
            };
        let index = lowerBound(0, length);
        if (index < length and Array.get(index, values) == key)
            Some(index)
        else
            None

    ///
    /// Returns the bucket index for the given key and capacity.
    ///
    pub def hashIndex(key: Int32, capacity: Int32): Option[Int32] =
        if (capacity <= 0)
            None
        else {
            let remainder = key `Int32.remainder` capacity;
            Some(if (remainder < 0) remainder + capacity else remainder)
        }

    ///
    /// Creates a separate-chaining hash table with the given capacity.
    ///
    pub def newHashTable(rc: Region[r], capacity: Int32): Array[List[(Int32, String)], r] \ r =
        Array.init(rc, _ -> Nil, if (capacity < 0) 0 else capacity)

    ///
    /// Finds the value associated with the key in the hash table.
    ///
    pub def hashSearch(key: Int32, buckets: Array[List[(Int32, String)], r]): Option[String] \ r =
        match hashIndex(key, Array.length(buckets)) {
            case None => None
            case Some(index) =>
                let entries = Array.get(index, buckets);
                def find(xs) = match xs {
                    case Nil => None
                    case (entryKey, value) :: rest =>
                        if (entryKey == key) Some(value) else find(rest)
                };
                find(entries)
        }

    ///
    /// Adds a key-value pair unless the key already exists.
    ///
    pub def hashAdd(key: Int32, value: String, buckets: Array[List[(Int32, String)], r]): Bool \ r =
        match hashIndex(key, Array.length(buckets)) {
            case None => false
            case Some(index) =>
                match hashSearch(key, buckets) {
                    case Some(_) => false
                    case None =>
                        let entries = Array.get(index, buckets);
                        Array.put((key, value) :: entries, index, buckets);
                        true
                }
        }

    ///
    /// Removes the key from the hash table.
    ///
    pub def hashRemove(key: Int32, buckets: Array[List[(Int32, String)], r]): Bool \ r =
        match hashIndex(key, Array.length(buckets)) {
            case None => false
            case Some(index) =>
                let entries = Array.get(index, buckets);
                def remove(xs) = match xs {
                    case Nil => None
                    case (entryKey, value) :: rest =>
                        if (entryKey == key)
                            Some(rest)
                        else
                            match remove(rest) {
                                case None => None
                                case Some(updated) => Some((entryKey, value) :: updated)
                            }
                };
                match remove(entries) {
                    case None => false
                    case Some(updated) =>
                        Array.put(updated, index, buckets);
                        true
                }
        }
}
