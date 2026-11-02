mod Recursion {
    def maxFactorialInput(): Int32 = 12

    ///
    /// Returns n! when n is within the non-negative Int32 range.
    ///
    pub def factorial(n: Int32): Option[Int32] =
        if (n < 0 or n > maxFactorialInput()) {
            None
        } else {
            def loop(value): Int32 =
                if (value <= 1)
                    1
                else
                    value * loop(value - 1);
            Some(loop(n))
        }

    ///
    /// Computes n! with a tail-recursive accumulator.
    ///
    pub def factorialIterative(n: Int32): Option[Int32] =
        if (n < 0 or n > maxFactorialInput()) {
            None
        } else {
            def loop(value, acc): Int32 =
                if (value > n)
                    acc
                else
                    loop(value + 1, acc * value);
            Some(loop(1, 1))
        }

    ///
    /// Returns the greatest common divisor for non-negative inputs.
    ///
    pub def gcd(x: Int32, y: Int32): Option[Int32] =
        if (x < 0 or y < 0) {
            None
        } else {
            def loop(a, b) =
                if (b == 0)
                    a
                else
                    loop(b, a `Int32.remainder` b);
            Some(loop(x, y))
        }

    ///
    /// Returns the moves for the Tower of Hanoi, in execution order.
    ///
    pub def hanoi(n: Int32, src: String, dst: String, via: String): List[(String, String)] =
        def append(xs, ys) = match xs {
            case Nil => ys
            case head :: tail => head :: append(tail, ys)
        };

        def moveDisks(disks, source, target, auxiliary) =
            if (disks <= 0) {
                Nil
            } else {
                append(
                    moveDisks(disks - 1, source, auxiliary, target),
                    (source, target) :: moveDisks(disks - 1, auxiliary, target, source)
                )
            };

        moveDisks(n, src, dst, via)

    ///
    /// Returns the values emitted by a function with two recursive calls.
    ///
    pub def recure(n: Int32): List[Int32] =
        def append(xs, ys) = match xs {
            case Nil => ys
            case head :: tail => head :: append(tail, ys)
        };

        def loop(value) =
            if (value <= 0) {
                Nil
            } else {
                append(loop(value - 1), value :: loop(value - 2))
            };

        loop(n)

    ///
    /// Replaces the second recursive branch with a tail-recursive loop.
    ///
    pub def recureTailLoop(n: Int32): List[Int32] =
        def append(xs, ys) = match xs {
            case Nil => ys
            case head :: tail => head :: append(tail, ys)
        };

        def recursive(value) =
            if (value <= 0) {
                Nil
            } else {
                append(recursive(value - 1), value :: recursive(value - 2))
            };

        def loop(value, output) =
            if (value <= 0) {
                output
            } else {
                loop(value - 2, append(append(output, recursive(value - 1)), value :: Nil))
            };

        loop(n, Nil)

    ///
    /// Simulates recursive calls with an explicit stack of pending tasks.
    ///
    pub def recureWithStack(n: Int32): List[Int32] =
        def reverse(xs) = {
            def loop(source, acc) = match source {
                case Nil => acc
                case head :: tail => loop(tail, head :: acc)
            };
            loop(xs, Nil)
        };

        @Tailrec
        def process(tasks, output) = match tasks {
            case Nil => reverse(output)
            case task :: tail =>
                let (isCall, value) = task;
                if (isCall) {
                    if (value <= 0) {
                        process(tail, output)
                    } else {
                        process(
                            (true, value - 1) :: (false, value) :: (true, value - 2) :: tail,
                            output
                        )
                    }
                } else {
                    process(tail, value :: output)
                }
        };

        process((true, n) :: Nil, Nil)

    ///
    /// Counts all row choices for a board of the given size.
    ///
    pub def queenPlacementCount(size: Int32): Int32 =
        if (size < 0) {
            0
        } else {
            def place(column) =
                if (column >= size) {
                    1
                } else {
                    def tryRows(row, count) =
                        if (row >= size) {
                            count
                        } else {
                            tryRows(row + 1, count + place(column + 1))
                        };
                    tryRows(0, 0)
                };

            place(0)
        }

    ///
    /// Counts placements that use each row at most once.
    ///
    pub def queenRowPermutationCount(size: Int32): Int32 =
        if (size < 0) {
            0
        } else {
            def isRowUnused(row, positions) = match positions {
                case Nil => true
                case head :: tail => row != head and isRowUnused(row, tail)
            };

            def place(column, positions) =
                if (column >= size) {
                    1
                } else {
                    def tryRows(row, count) =
                        if (row >= size) {
                            count
                        } else if (isRowUnused(row, positions)) {
                            tryRows(row + 1, count + place(column + 1, row :: positions))
                        } else {
                            tryRows(row + 1, count)
                        };
                    tryRows(0, 0)
                };

            place(0, Nil)
        }

    ///
    /// Returns all queen placements that do not share rows or diagonals.
    ///
    pub def queensSolutions(size: Int32): List[List[Int32]] =
        if (size < 0) {
            Nil
        } else {
            def reverseRows(xs: List[Int32]): List[Int32] = {
                def loop(source, acc) = match source {
                    case Nil => acc
                    case head :: tail => loop(tail, head :: acc)
                };
                loop(xs, Nil)
            };

            def reverseSolutions(xs: List[List[Int32]]): List[List[Int32]] = {
                def loop(source, acc) = match source {
                    case Nil => acc
                    case head :: tail => loop(tail, head :: acc)
                };
                loop(xs, Nil)
            };

            def isSafe(candidateRow, usedPositions) = {
                def check(previous, distance) = match previous {
                    case Nil => true
                    case previousRow :: tail =>
                        if (
                            candidateRow == previousRow or
                            candidateRow - previousRow == distance or
                            previousRow - candidateRow == distance
                        ) {
                            false
                        } else {
                            check(tail, distance + 1)
                        }
                };
                check(usedPositions, 1)
            };

            def place(column, positions, solutions) =
                if (column >= size) {
                    reverseRows(positions) :: solutions
                } else {
                    def tryRows(candidateRow, acc) =
                        if (candidateRow >= size) {
                            acc
                        } else if (isSafe(candidateRow, positions)) {
                            tryRows(candidateRow + 1, place(column + 1, candidateRow :: positions, acc))
                        } else {
                            tryRows(candidateRow + 1, acc)
                        };
                    tryRows(0, solutions)
                };

            reverseSolutions(place(0, Nil, Nil))
        }

    ///
    /// Returns the value at a list index, or None when the index is invalid.
    ///
    def listAt(xs: List[a], index: Int32): Option[a] =
        if (index < 0) {
            None
        } else {
            match xs {
                case Nil => None
                case head :: tail => if (index == 0) Some(head) else listAt(tail, index - 1)
            }
        }

    ///
    /// Searches an immutable, zero-for-open maze with recursive backtracking.
    ///
    pub def mazeSolve(
        maze: List[List[Int32]],
        row: Int32,
        col: Int32,
        goalRow: Int32,
        goalCol: Int32
    ): Bool =
        def contains(position, visited) = match visited {
            case Nil => false
            case (visitedRow, visitedCol) :: tail =>
                (position == (visitedRow, visitedCol)) or contains(position, tail)
        };

        def cellAt(r, c) = match listAt(maze, r) {
            case None => None
            case Some(cells) => listAt(cells, c)
        };

        def search(r, c, visited) =
            if (contains((r, c), visited)) {
                (false, visited)
            } else {
                match cellAt(r, c) {
                    case Some(0) =>
                        let updatedVisited = (r, c) :: visited;
                        if (r == goalRow and c == goalCol) {
                            (true, updatedVisited)
                        } else {
                            def tryDirections(directions, seen) = match directions {
                                case Nil => (false, seen)
                                case (dr, dc) :: tail =>
                                    let (found, nextSeen) = search(r + dr, c + dc, seen);
                                    if (found) {
                                        (true, nextSeen)
                                    } else {
                                        tryDirections(tail, nextSeen)
                                    }
                            };

                            tryDirections(
                                (-1, 0) :: (1, 0) :: (0, -1) :: (0, 1) :: Nil,
                                updatedVisited
                            )
                        }
                    case _ => (false, visited)
                }
            };

        let (found, _) = search(row, col, Nil);
        found
}
