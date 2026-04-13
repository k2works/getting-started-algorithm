module Chapter06Tests

open Xunit
open SortAlgorithms

// 第6章 ソートアルゴリズム テスト

let shuffleArr (a: int[]) =
    let r = System.Random(42)
    let b = Array.copy a
    for i in b.Length-1 .. -1 .. 1 do
        let j = r.Next(i + 1)
        let tmp = b.[i]
        b.[i] <- b.[j]
        b.[j] <- tmp
    b

module BubbleSortTests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in bubbleSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in bubbleSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``単一要素``() = let a = [|42|] in bubbleSort a; Assert.Equal<int[]>([|42|], a)
    [<Fact>]
    let ``空配列``() = let a: int[] = [||] in bubbleSort a; Assert.Equal<int[]>([||], a)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in bubbleSort a; Assert.Equal<int[]>([|1;1;2;3;3|], a)

module BubbleSort2Tests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in bubbleSort2 a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in bubbleSort2 a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in bubbleSort2 a; Assert.Equal<int[]>([|1;1;2;3;3|], a)

module ShakerSortTests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in shakerSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in shakerSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in shakerSort a; Assert.Equal<int[]>([|1;1;2;3;3|], a)

module SelectionSortTests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in selectionSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in selectionSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``単一要素``() = let a = [|5|] in selectionSort a; Assert.Equal<int[]>([|5|], a)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in selectionSort a; Assert.Equal<int[]>([|1;1;2;3;3|], a)

module InsertionSortTests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in insertionSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in insertionSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``単一要素``() = let a = [|7|] in insertionSort a; Assert.Equal<int[]>([|7|], a)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in insertionSort a; Assert.Equal<int[]>([|1;1;2;3;3|], a)

module BinaryInsertionSortTests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in binaryInsertionSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in binaryInsertionSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in binaryInsertionSort a; Assert.Equal<int[]>([|1;1;2;3;3|], a)

module ShellSortTests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in shellSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in shellSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``大きな配列``() =
        let a = Array.init 100 id
        let shuffled = shuffleArr a
        shellSort shuffled
        Assert.Equal<int[]>(a, shuffled)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in shellSort a; Assert.Equal<int[]>([|1;1;2;3;3|], a)

module QuickSortTests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in quickSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in quickSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``単一要素``() = let a = [|1|] in quickSort a; Assert.Equal<int[]>([|1|], a)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in quickSort a; Assert.Equal<int[]>([|1;1;2;3;3|], a)
    [<Fact>]
    let ``大きな配列``() =
        let a = Array.init 200 id
        let shuffled = shuffleArr a
        quickSort shuffled
        Assert.Equal<int[]>(a, shuffled)

module QuickSortNonRecursiveTests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in quickSortNonRecursive a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in quickSortNonRecursive a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in quickSortNonRecursive a; Assert.Equal<int[]>([|1;1;2;3;3|], a)

module MergeSortedArraysTests =
    [<Fact>]
    let ``基本``() = Assert.Equal<int[]>([|1;2;3;4;5;6|], mergeSortedArrays [|1;3;5|] [|2;4;6|])
    [<Fact>]
    let ``一方が空``() = Assert.Equal<int[]>([|1;2;3|], mergeSortedArrays [||] [|1;2;3|])
    [<Fact>]
    let ``重複あり``() = Assert.Equal<int[]>([|1;2;2;3;4|], mergeSortedArrays [|1;2;4|] [|2;3|])

module MergeSortTests =
    [<Fact>]
    let ``基本``() = Assert.Equal<int[]>([|1;3;4;6;7;8;9|], mergeSort [|6;4;3;7;1;9;8|])
    [<Fact>]
    let ``整列済み``() = Assert.Equal<int[]>([|1;3;4;6;7;8;9|], mergeSort [|1;3;4;6;7;8;9|])
    [<Fact>]
    let ``単一要素``() = Assert.Equal<int[]>([|5|], mergeSort [|5|])
    [<Fact>]
    let ``空配列``() = Assert.Equal<int[]>([||], mergeSort [||])
    [<Fact>]
    let ``重複``() = Assert.Equal<int[]>([|1;1;2;3;3|], mergeSort [|3;1;2;1;3|])

module HeapSortTests =
    [<Fact>]
    let ``基本``() = let a = [|6;4;3;7;1;9;8|] in heapSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``整列済み``() = let a = [|1;3;4;6;7;8;9|] in heapSort a; Assert.Equal<int[]>([|1;3;4;6;7;8;9|], a)
    [<Fact>]
    let ``単一要素``() = let a = [|42|] in heapSort a; Assert.Equal<int[]>([|42|], a)
    [<Fact>]
    let ``空配列``() = let a: int[] = [||] in heapSort a; Assert.Equal<int[]>([||], a)
    [<Fact>]
    let ``重複``() = let a = [|3;1;2;1;3|] in heapSort a; Assert.Equal<int[]>([|1;1;2;3;3|], a)

module CountingSortTests =
    [<Fact>]
    let ``基本``() = Assert.Equal<int[]>([|1;3;4;6;7;8;9|], countingSort [|6;4;3;7;1;9;8|])
    [<Fact>]
    let ``整列済み``() = Assert.Equal<int[]>([|1;3;4;6;7;8;9|], countingSort [|1;3;4;6;7;8;9|])
    [<Fact>]
    let ``単一要素``() = Assert.Equal<int[]>([|5|], countingSort [|5|])
    [<Fact>]
    let ``空配列``() = Assert.Equal<int[]>([||], countingSort [||])
    [<Fact>]
    let ``重複``() = Assert.Equal<int[]>([|1;1;2;3;3|], countingSort [|3;1;2;1;3|])
