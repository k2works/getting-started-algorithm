mod Sort {
    ///
    /// Sorts the array in place with an early-exit bubble sort.
    ///
    pub def bubbleSort(values: Array[Int32, r]): Unit \ r =
        let length = Array.length(values);

        def pass(i) =
            if (i >= length - 1) {
                ()
            } else {
                def compare(j, swapped) =
                    if (j <= i) {
                        if (swapped) pass(i + 1) else ()
                    } else {
                        let left = Array.get(j - 1, values);
                        let right = Array.get(j, values);
                        if (left > right) {
                            Array.put(right, j - 1, values);
                            Array.put(left, j, values);
                            compare(j - 1, true)
                        } else {
                            compare(j - 1, swapped)
                        }
                    };
                compare(length - 1, false)
            };

        pass(0)

    ///
    /// Sorts the array in place by repeatedly selecting the smallest value.
    ///
    pub def selectionSort(values: Array[Int32, r]): Unit \ r =
        let length = Array.length(values);

        def selectionPass(i) =
            if (i >= length - 1) {
                ()
            } else {
                def findMinimum(j, minimumIndex) =
                    if (j >= length) {
                        minimumIndex
                    } else if (Array.get(j, values) < Array.get(minimumIndex, values)) {
                        findMinimum(j + 1, j)
                    } else {
                        findMinimum(j + 1, minimumIndex)
                    };

                let minimumIndex = findMinimum(i + 1, i);
                if (minimumIndex != i) {
                    let current = Array.get(i, values);
                    let minimum = Array.get(minimumIndex, values);
                    Array.put(minimum, i, values);
                    Array.put(current, minimumIndex, values)
                };
                selectionPass(i + 1)
            };

        selectionPass(0)

    ///
    /// Sorts the array in place by inserting each value into the sorted prefix.
    ///
    pub def insertionSort(values: Array[Int32, r]): Unit \ r =
        let length = Array.length(values);

        def insert(i) =
            if (i >= length) {
                ()
            } else {
                let value = Array.get(i, values);
                def shift(j) =
                    if (j <= 0) {
                        j
                    } else {
                        let previous = Array.get(j - 1, values);
                        if (previous > value) {
                            Array.put(previous, j, values);
                            shift(j - 1)
                        } else {
                            j
                        }
                    };
                let position = shift(i);
                Array.put(value, position, values);
                insert(i + 1)
            };

        insert(1)

    ///
    /// Returns a sorted list using recursive partitioning.
    ///
    pub def quickSort(values: List[Int32]): List[Int32] =
        def append(xs, ys) = match xs {
            case Nil => ys
            case head :: tail => head :: append(tail, ys)
        };

        def partition(xs, pivot, less, greater) = match xs {
            case Nil => (less, greater)
            case head :: tail =>
                if (head < pivot) {
                    partition(tail, pivot, head :: less, greater)
                } else {
                    partition(tail, pivot, less, head :: greater)
                }
        };

        def sort(xs) = match xs {
            case Nil => Nil
            case pivot :: tail =>
                let (less, greater) = partition(tail, pivot, Nil, Nil);
                append(sort(less), pivot :: sort(greater))
        };

        sort(values)

    ///
    /// Sorts the array in place with a stable merge sort and one scratch array.
    ///
    pub def mergeSort(values: Array[Int32, r]): Unit \ r =
        let length = Array.length(values);
        region rc {
            let scratch = Array.repeat(rc, length, 0);

            def sort(low, high) =
                if (low >= high) {
                    ()
                } else {
                    let middle = low + (high - low) / 2;
                    sort(low, middle);
                    sort(middle + 1, high);

                    def merge(left, right, output) =
                        if (output > high) {
                            ()
                        } else if (left > middle) {
                            Array.put(Array.get(right, values), output, scratch);
                            merge(left, right + 1, output + 1)
                        } else if (right > high) {
                            Array.put(Array.get(left, values), output, scratch);
                            merge(left + 1, right, output + 1)
                        } else {
                            let leftValue = Array.get(left, values);
                            let rightValue = Array.get(right, values);
                            if (leftValue <= rightValue) {
                                Array.put(leftValue, output, scratch);
                                merge(left + 1, right, output + 1)
                            } else {
                                Array.put(rightValue, output, scratch);
                                merge(left, right + 1, output + 1)
                            }
                        };

                    def copyBack(i) =
                        if (i > high) {
                            ()
                        } else {
                            Array.put(Array.get(i, scratch), i, values);
                            copyBack(i + 1)
                        };

                    merge(low, middle + 1, low);
                    copyBack(low)
                };

            sort(0, length - 1)
        }
}
