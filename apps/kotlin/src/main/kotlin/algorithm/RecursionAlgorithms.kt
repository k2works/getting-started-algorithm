package algorithm

object RecursionAlgorithms {
    private data class RecursionFrame(val value: Int, val appendOnResume: Boolean)

    fun factorial(n: Int): Long {
        require(n in 0..MAX_FACTORIAL_ARGUMENT) { "n は 0 以上 20 以下でなければなりません。" }
        if (n <= 1) return 1
        return n * factorial(n - 1)
    }

    fun factorialTailRecursive(n: Int): Long {
        require(n in 0..MAX_FACTORIAL_ARGUMENT) { "n は 0 以上 20 以下でなければなりません。" }
        tailrec fun calculate(remaining: Int, result: Long): Long =
            if (remaining <= 1) result else calculate(remaining - 1, result * remaining)

        return calculate(n, 1)
    }

    fun factorialIterative(n: Int): Long {
        require(n in 0..MAX_FACTORIAL_ARGUMENT) { "n は 0 以上 20 以下でなければなりません。" }
        var result = 1L
        for (factor in 2..n) result *= factor
        return result
    }

    fun gcd(x: Int, y: Int): Int {
        require(x >= 0 && y >= 0) { "x と y は 0 以上でなければなりません。" }
        tailrec fun calculate(a: Int, b: Int): Int =
            if (b == 0) a else calculate(b, a % b)

        return calculate(x, y)
    }

    fun gcdIterative(x: Int, y: Int): Int {
        require(x >= 0 && y >= 0) { "x と y は 0 以上でなければなりません。" }
        var a = x
        var b = y
        while (b != 0) {
            val remainder = a % b
            a = b
            b = remainder
        }
        return a
    }

    fun hanoi(disks: Int, source: String, destination: String, auxiliary: String): List<String> {
        require(disks >= 0) { "円盤の枚数は 0 以上でなければなりません。" }
        require(source != destination && source != auxiliary && destination != auxiliary) {
            "移動元、移動先、補助の柱はそれぞれ異なる必要があります。"
        }
        val moves = mutableListOf<String>()

        fun move(disksToMove: Int, from: String, to: String, via: String) {
            if (disksToMove == 0) return
            move(disksToMove - 1, from, via, to)
            moves.add("$from->$to")
            move(disksToMove - 1, via, to, from)
        }

        move(disks, source, destination, auxiliary)
        return moves
    }

    fun multipleRecursion(n: Int): List<Int> {
        val result = mutableListOf<Int>()

        fun recur(value: Int) {
            if (value <= 0) return
            recur(value - 1)
            result.add(value)
            recur(value - 2)
        }

        recur(n)
        return result
    }

    fun multipleRecursionPartiallyIterative(n: Int): List<Int> {
        val result = mutableListOf<Int>()

        fun recur(value: Int) {
            var current = value
            while (current > 0) {
                recur(current - 1)
                result.add(current)
                current -= 2
            }
        }

        recur(n)
        return result
    }

    fun multipleRecursionIterative(n: Int): List<Int> {
        val result = mutableListOf<Int>()
        val frames = mutableListOf(RecursionFrame(n, appendOnResume = false))

        while (frames.isNotEmpty()) {
            val frame = frames.removeAt(frames.lastIndex)
            if (frame.appendOnResume) {
                result.add(frame.value)
            } else if (frame.value > 0) {
                frames.add(RecursionFrame(frame.value - 2, appendOnResume = false))
                frames.add(RecursionFrame(frame.value, appendOnResume = true))
                frames.add(RecursionFrame(frame.value - 1, appendOnResume = false))
            }
        }
        return result
    }

    fun countUnrestrictedEightQueens(): Int {
        var count = 0

        fun place(column: Int) {
            for (row in 0 until BOARD_SIZE) {
                if (column == BOARD_SIZE - 1) count++ else place(column + 1)
            }
        }

        place(0)
        return count
    }

    fun eightQueensWithUniqueRows(): List<IntArray> {
        val positions = IntArray(BOARD_SIZE)
        val usedRows = BooleanArray(BOARD_SIZE)
        val solutions = mutableListOf<IntArray>()

        fun place(column: Int) {
            for (row in 0 until BOARD_SIZE) {
                if (usedRows[row]) continue
                positions[column] = row
                if (column == BOARD_SIZE - 1) {
                    solutions.add(positions.copyOf())
                } else {
                    usedRows[row] = true
                    place(column + 1)
                    usedRows[row] = false
                }
            }
        }

        place(0)
        return solutions
    }

    fun solveEightQueens(): List<IntArray> {
        val positions = IntArray(BOARD_SIZE)
        val usedRows = BooleanArray(BOARD_SIZE)
        val descendingDiagonals = BooleanArray(2 * BOARD_SIZE - 1)
        val ascendingDiagonals = BooleanArray(2 * BOARD_SIZE - 1)
        val solutions = mutableListOf<IntArray>()

        fun place(column: Int) {
            for (row in 0 until BOARD_SIZE) {
                val descending = column + row
                val ascending = column - row + BOARD_SIZE - 1
                if (usedRows[row] || descendingDiagonals[descending] || ascendingDiagonals[ascending]) {
                    continue
                }

                positions[column] = row
                usedRows[row] = true
                descendingDiagonals[descending] = true
                ascendingDiagonals[ascending] = true
                if (column == BOARD_SIZE - 1) {
                    solutions.add(positions.copyOf())
                } else {
                    place(column + 1)
                }
                usedRows[row] = false
                descendingDiagonals[descending] = false
                ascendingDiagonals[ascending] = false
            }
        }

        place(0)
        return solutions
    }

    fun mazeSolve(
        maze: Array<IntArray>,
        startRow: Int,
        startColumn: Int,
        goalRow: Int,
        goalColumn: Int,
    ): Boolean {
        require(maze.isNotEmpty() && maze[0].isNotEmpty()) { "迷路は空にできません。" }
        val columnCount = maze[0].size
        require(maze.all { it.size == columnCount }) { "迷路はすべての行が同じ長さでなければなりません。" }
        require(maze.all { row -> row.all { it == PATH || it == WALL } }) {
            "迷路の各セルは通路 0 または壁 1 でなければなりません。"
        }
        require(startRow in maze.indices && startColumn in 0 until columnCount) {
            "開始位置が迷路の範囲外です。"
        }
        require(goalRow in maze.indices && goalColumn in 0 until columnCount) {
            "ゴール位置が迷路の範囲外です。"
        }
        if (maze[startRow][startColumn] == WALL || maze[goalRow][goalColumn] == WALL) return false

        val visited = Array(maze.size) { BooleanArray(columnCount) }
        fun search(row: Int, column: Int): Boolean {
            if (row == goalRow && column == goalColumn) return true
            visited[row][column] = true

            for ((rowOffset, columnOffset) in DIRECTIONS) {
                val nextRow = row + rowOffset
                val nextColumn = column + columnOffset
                if (nextRow in maze.indices && nextColumn in 0 until columnCount &&
                    maze[nextRow][nextColumn] == PATH && !visited[nextRow][nextColumn] &&
                    search(nextRow, nextColumn)
                ) {
                    return true
                }
            }
            return false
        }

        return search(startRow, startColumn)
    }

    private const val MAX_FACTORIAL_ARGUMENT = 20
    private const val BOARD_SIZE = 8
    private const val PATH = 0
    private const val WALL = 1
    private val DIRECTIONS = listOf(-1 to 0, 1 to 0, 0 to -1, 0 to 1)
}
