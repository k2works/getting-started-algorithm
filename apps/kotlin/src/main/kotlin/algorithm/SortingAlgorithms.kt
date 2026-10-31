package algorithm

object SortingAlgorithms {
    fun bubbleSort(values: IntArray) {
        for (start in 0 until values.lastIndex) {
            var swapped = false
            for (index in values.lastIndex downTo start + 1) {
                if (values[index - 1] > values[index]) {
                    swap(values, index - 1, index)
                    swapped = true
                }
            }
            if (!swapped) return
        }
    }

    fun selectionSort(values: IntArray) {
        for (start in 0 until values.lastIndex) {
            var minimumIndex = start
            for (index in start + 1..values.lastIndex) {
                if (values[index] < values[minimumIndex]) minimumIndex = index
            }
            if (minimumIndex != start) swap(values, start, minimumIndex)
        }
    }

    fun insertionSort(values: IntArray) {
        for (index in 1..values.lastIndex) {
            val value = values[index]
            var insertionIndex = index
            while (insertionIndex > 0 && values[insertionIndex - 1] > value) {
                values[insertionIndex] = values[insertionIndex - 1]
                insertionIndex--
            }
            values[insertionIndex] = value
        }
    }

    fun quickSort(values: IntArray) {
        fun sort(left: Int, right: Int) {
            if (left >= right) return

            var low = left
            var high = right
            val pivot = values[left + (right - left) / 2]
            while (low <= high) {
                while (values[low] < pivot) low++
                while (values[high] > pivot) high--
                if (low <= high) {
                    swap(values, low, high)
                    low++
                    high--
                }
            }
            sort(left, high)
            sort(low, right)
        }

        sort(0, values.lastIndex)
    }

    fun <T : Comparable<T>> mergeSort(input: List<T>): List<T> {
        val values = input.toMutableList()
        val buffer = values.toMutableList()

        fun sort(left: Int, right: Int) {
            if (left >= right) return
            val middle = left + (right - left) / 2
            sort(left, middle)
            sort(middle + 1, right)

            var leftIndex = left
            var rightIndex = middle + 1
            for (index in left..right) {
                when {
                    leftIndex > middle -> buffer[index] = values[rightIndex++]
                    rightIndex > right -> buffer[index] = values[leftIndex++]
                    values[leftIndex] <= values[rightIndex] ->
                        buffer[index] = values[leftIndex++]
                    else -> buffer[index] = values[rightIndex++]
                }
            }
            for (index in left..right) values[index] = buffer[index]
        }

        sort(0, values.lastIndex)
        return values.toList()
    }

    private fun swap(values: IntArray, first: Int, second: Int) {
        val temporary = values[first]
        values[first] = values[second]
        values[second] = temporary
    }
}
