// chapter09: 木構造

// =============================================================================
// 二分探索木（BST: Binary Search Tree）
// =============================================================================

type TreeLink<T> = Option<Box<TreeNode<T>>>;

struct TreeNode<T> {
    data: T,
    left: TreeLink<T>,
    right: TreeLink<T>,
}

/// 二分探索木
///
/// 性質:
/// - 左部分木のすべてのキー < ルートのキー
/// - 右部分木のすべてのキー > ルートのキー
/// - 左右の部分木もまた二分探索木
pub struct BinarySearchTree<T> {
    root: TreeLink<T>,
    len: usize,
}

impl<T: Ord + Clone + std::fmt::Debug> BinarySearchTree<T> {
    /// 空の二分探索木を生成する
    pub fn new() -> Self {
        BinarySearchTree {
            root: None,
            len: 0,
        }
    }

    /// 木が空かどうかを返す
    pub fn is_empty(&self) -> bool {
        self.root.is_none()
    }

    /// ノード数を返す
    pub fn len(&self) -> usize {
        self.len
    }

    /// キーを挿入する（重複は無視）
    pub fn insert(&mut self, data: T) {
        if Self::insert_recursive(&mut self.root, data) {
            self.len += 1;
        }
    }

    fn insert_recursive(link: &mut TreeLink<T>, data: T) -> bool {
        match link {
            None => {
                *link = Some(Box::new(TreeNode {
                    data,
                    left: None,
                    right: None,
                }));
                true
            }
            Some(node) => {
                if data == node.data {
                    false // 重複は無視
                } else if data < node.data {
                    Self::insert_recursive(&mut node.left, data)
                } else {
                    Self::insert_recursive(&mut node.right, data)
                }
            }
        }
    }

    /// キーを探索し、存在すれば true を返す
    pub fn search(&self, data: &T) -> bool {
        let mut current = &self.root;
        while let Some(node) = current {
            if *data == node.data {
                return true;
            } else if *data < node.data {
                current = &node.left;
            } else {
                current = &node.right;
            }
        }
        false
    }

    /// キーを削除し、成功すれば true を返す
    pub fn remove(&mut self, data: &T) -> bool {
        if Self::remove_recursive(&mut self.root, data) {
            self.len -= 1;
            true
        } else {
            false
        }
    }

    fn remove_recursive(link: &mut TreeLink<T>, data: &T) -> bool {
        if link.is_none() {
            return false;
        }

        let node_data = link.as_ref().unwrap().data.clone();

        if *data < node_data {
            Self::remove_recursive(&mut link.as_mut().unwrap().left, data)
        } else if *data > node_data {
            Self::remove_recursive(&mut link.as_mut().unwrap().right, data)
        } else {
            // 見つかった: 削除処理
            let node = link.as_mut().unwrap();
            if node.left.is_none() {
                // 左子なし: 右子で置き換え
                *link = link.take().unwrap().right;
            } else if node.right.is_none() {
                // 右子なし: 左子で置き換え
                *link = link.take().unwrap().left;
            } else {
                // 子が 2 つ: 右部分木の最小値（中順後継）で置き換え
                let successor_data = Self::find_min(&node.right).unwrap().clone();
                link.as_mut().unwrap().data = successor_data.clone();
                Self::remove_recursive(&mut link.as_mut().unwrap().right, &successor_data);
            }
            true
        }
    }

    fn find_min(link: &TreeLink<T>) -> Option<&T> {
        match link {
            None => None,
            Some(node) => {
                if node.left.is_none() {
                    Some(&node.data)
                } else {
                    Self::find_min(&node.left)
                }
            }
        }
    }

    /// 最小キーを返す
    pub fn min(&self) -> Option<&T> {
        Self::find_min(&self.root)
    }

    /// 最大キーを返す
    pub fn max(&self) -> Option<&T> {
        let mut current = &self.root;
        let mut result = None;
        while let Some(node) = current {
            result = Some(&node.data);
            current = &node.right;
        }
        result
    }

    /// 中順走査（昇順）
    pub fn inorder(&self) -> Vec<T> {
        let mut result = Vec::new();
        Self::inorder_recursive(&self.root, &mut result);
        result
    }

    fn inorder_recursive(link: &TreeLink<T>, result: &mut Vec<T>) {
        if let Some(node) = link {
            Self::inorder_recursive(&node.left, result);
            result.push(node.data.clone());
            Self::inorder_recursive(&node.right, result);
        }
    }

    /// 前順走査
    pub fn preorder(&self) -> Vec<T> {
        let mut result = Vec::new();
        Self::preorder_recursive(&self.root, &mut result);
        result
    }

    fn preorder_recursive(link: &TreeLink<T>, result: &mut Vec<T>) {
        if let Some(node) = link {
            result.push(node.data.clone());
            Self::preorder_recursive(&node.left, result);
            Self::preorder_recursive(&node.right, result);
        }
    }

    /// 後順走査
    pub fn postorder(&self) -> Vec<T> {
        let mut result = Vec::new();
        Self::postorder_recursive(&self.root, &mut result);
        result
    }

    fn postorder_recursive(link: &TreeLink<T>, result: &mut Vec<T>) {
        if let Some(node) = link {
            Self::postorder_recursive(&node.left, result);
            Self::postorder_recursive(&node.right, result);
            result.push(node.data.clone());
        }
    }
}

// =============================================================================
// 最小ヒープ（MinHeap）
// =============================================================================

/// 最小ヒープ
///
/// 完全二分木を配列で表現する。
/// ヒープ条件: すべてのノードで 親 <= 子
pub struct MinHeap<T> {
    data: Vec<T>,
}

impl<T: Ord + Clone> MinHeap<T> {
    /// 空のヒープを生成する
    pub fn new() -> Self {
        MinHeap { data: Vec::new() }
    }

    /// 要素を追加する（上方向に浮かせる）
    pub fn push(&mut self, item: T) {
        self.data.push(item);
        self.sift_up(self.data.len() - 1);
    }

    /// 最小要素を取り出す（下方向に沈める）
    pub fn pop(&mut self) -> Option<T> {
        if self.data.is_empty() {
            return None;
        }
        let last = self.data.len() - 1;
        self.data.swap(0, last);
        let result = self.data.pop();
        if !self.data.is_empty() {
            self.sift_down(0);
        }
        result
    }

    /// 最小要素を参照する
    pub fn peek(&self) -> Option<&T> {
        self.data.first()
    }

    /// 要素数を返す
    pub fn len(&self) -> usize {
        self.data.len()
    }

    /// ヒープが空かどうかを返す
    pub fn is_empty(&self) -> bool {
        self.data.is_empty()
    }

    fn sift_up(&mut self, mut idx: usize) {
        while idx > 0 {
            let parent = (idx - 1) / 2;
            if self.data[parent] <= self.data[idx] {
                break;
            }
            self.data.swap(parent, idx);
            idx = parent;
        }
    }

    fn sift_down(&mut self, mut idx: usize) {
        let len = self.data.len();
        loop {
            let left = 2 * idx + 1;
            let right = 2 * idx + 2;
            let mut smallest = idx;

            if left < len && self.data[left] < self.data[smallest] {
                smallest = left;
            }
            if right < len && self.data[right] < self.data[smallest] {
                smallest = right;
            }
            if smallest == idx {
                break;
            }
            self.data.swap(idx, smallest);
            idx = smallest;
        }
    }
}

// =============================================================================
// テスト
// =============================================================================

#[cfg(test)]
mod tests {
    use super::*;

    // =========================================================================
    // 二分探索木テスト
    // =========================================================================

    mod bst_tests {
        use super::*;

        #[test]
        fn test_initial_empty() {
            let bst: BinarySearchTree<i32> = BinarySearchTree::new();
            assert!(bst.is_empty());
            assert_eq!(bst.len(), 0);
        }

        #[test]
        fn test_insert_and_search() {
            let mut bst = BinarySearchTree::new();
            bst.insert(5);
            assert!(bst.search(&5));
            assert!(!bst.is_empty());
        }

        #[test]
        fn test_search_not_found() {
            let bst: BinarySearchTree<i32> = BinarySearchTree::new();
            assert!(!bst.search(&99));
        }

        #[test]
        fn test_insert_multiple() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7, 1, 4, 6, 8] {
                bst.insert(v);
            }
            for v in [5, 3, 7, 1, 4, 6, 8] {
                assert!(bst.search(&v));
            }
            assert_eq!(bst.len(), 7);
        }

        #[test]
        fn test_insert_duplicate() {
            let mut bst = BinarySearchTree::new();
            bst.insert(5);
            bst.insert(5);
            assert_eq!(bst.len(), 1);
        }

        #[test]
        fn test_inorder_traversal() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7, 1, 4, 6, 8] {
                bst.insert(v);
            }
            assert_eq!(bst.inorder(), vec![1, 3, 4, 5, 6, 7, 8]);
        }

        #[test]
        fn test_preorder_traversal() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7] {
                bst.insert(v);
            }
            assert_eq!(bst.preorder(), vec![5, 3, 7]);
        }

        #[test]
        fn test_postorder_traversal() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7] {
                bst.insert(v);
            }
            assert_eq!(bst.postorder(), vec![3, 7, 5]);
        }

        #[test]
        fn test_min() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7, 1, 4] {
                bst.insert(v);
            }
            assert_eq!(bst.min(), Some(&1));
        }

        #[test]
        fn test_max() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7, 1, 4] {
                bst.insert(v);
            }
            assert_eq!(bst.max(), Some(&7));
        }

        #[test]
        fn test_min_empty() {
            let bst: BinarySearchTree<i32> = BinarySearchTree::new();
            assert_eq!(bst.min(), None);
        }

        #[test]
        fn test_max_empty() {
            let bst: BinarySearchTree<i32> = BinarySearchTree::new();
            assert_eq!(bst.max(), None);
        }

        #[test]
        fn test_delete_leaf() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7] {
                bst.insert(v);
            }
            assert!(bst.remove(&3));
            assert!(!bst.search(&3));
            assert!(bst.search(&5));
            assert!(bst.search(&7));
        }

        #[test]
        fn test_delete_node_with_one_child() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7, 1] {
                bst.insert(v);
            }
            assert!(bst.remove(&3));
            assert!(!bst.search(&3));
            assert!(bst.search(&1));
        }

        #[test]
        fn test_delete_node_with_two_children() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7, 1, 4] {
                bst.insert(v);
            }
            assert!(bst.remove(&3));
            assert!(!bst.search(&3));
            for v in [1, 4, 5, 7] {
                assert!(bst.search(&v));
            }
        }

        #[test]
        fn test_delete_root() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7] {
                bst.insert(v);
            }
            assert!(bst.remove(&5));
            assert!(!bst.search(&5));
            assert!(bst.search(&3));
            assert!(bst.search(&7));
            assert_eq!(bst.inorder(), vec![3, 7]);
        }

        #[test]
        fn test_delete_not_found() {
            let mut bst = BinarySearchTree::new();
            bst.insert(5);
            assert!(!bst.remove(&99));
            assert!(bst.search(&5));
        }

        #[test]
        fn test_delete_single_root() {
            let mut bst = BinarySearchTree::new();
            bst.insert(5);
            assert!(bst.remove(&5));
            assert!(bst.is_empty());
        }

        #[test]
        fn test_delete_right_child_only() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7, 8] {
                bst.insert(v);
            }
            assert!(bst.remove(&7));
            assert!(!bst.search(&7));
            assert!(bst.search(&8));
        }

        #[test]
        fn test_delete_node_with_deep_successor() {
            let mut bst = BinarySearchTree::new();
            for v in [10, 5, 20, 15, 25, 12, 18] {
                bst.insert(v);
            }
            assert!(bst.remove(&10));
            assert!(!bst.search(&10));
            assert_eq!(bst.inorder(), vec![5, 12, 15, 18, 20, 25]);
        }

        #[test]
        fn test_delete_right_child_of_parent() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7] {
                bst.insert(v);
            }
            assert!(bst.remove(&7));
            assert!(!bst.search(&7));
            assert!(bst.search(&5));
        }

        #[test]
        fn test_len_after_operations() {
            let mut bst = BinarySearchTree::new();
            for v in [5, 3, 7] {
                bst.insert(v);
            }
            assert_eq!(bst.len(), 3);
            bst.remove(&3);
            assert_eq!(bst.len(), 2);
        }

        #[test]
        fn test_contains() {
            let mut bst = BinarySearchTree::new();
            bst.insert(42);
            assert!(bst.search(&42));
            assert!(!bst.search(&0));
        }
    }

    // =========================================================================
    // 最小ヒープテスト
    // =========================================================================

    mod heap_tests {
        use super::*;

        #[test]
        fn test_heap_new_is_empty() {
            let heap: MinHeap<i32> = MinHeap::new();
            assert!(heap.is_empty());
            assert_eq!(heap.len(), 0);
        }

        #[test]
        fn test_heap_push_and_peek() {
            let mut heap = MinHeap::new();
            heap.push(5);
            assert_eq!(heap.peek(), Some(&5));
            heap.push(3);
            assert_eq!(heap.peek(), Some(&3));
            heap.push(7);
            assert_eq!(heap.peek(), Some(&3));
        }

        #[test]
        fn test_heap_push_and_pop() {
            let mut heap = MinHeap::new();
            heap.push(5);
            heap.push(3);
            heap.push(7);
            heap.push(1);
            assert_eq!(heap.pop(), Some(1));
            assert_eq!(heap.pop(), Some(3));
            assert_eq!(heap.pop(), Some(5));
            assert_eq!(heap.pop(), Some(7));
            assert_eq!(heap.pop(), None);
        }

        #[test]
        fn test_heap_pop_empty() {
            let mut heap: MinHeap<i32> = MinHeap::new();
            assert_eq!(heap.pop(), None);
        }

        #[test]
        fn test_heap_len() {
            let mut heap = MinHeap::new();
            heap.push(3);
            heap.push(1);
            heap.push(4);
            assert_eq!(heap.len(), 3);
            heap.pop();
            assert_eq!(heap.len(), 2);
        }

        #[test]
        fn test_heap_single_element() {
            let mut heap = MinHeap::new();
            heap.push(42);
            assert_eq!(heap.peek(), Some(&42));
            assert_eq!(heap.pop(), Some(42));
            assert!(heap.is_empty());
        }

        #[test]
        fn test_heap_sorted_input() {
            let mut heap = MinHeap::new();
            for v in [1, 2, 3, 4, 5] {
                heap.push(v);
            }
            let mut result = Vec::new();
            while let Some(v) = heap.pop() {
                result.push(v);
            }
            assert_eq!(result, vec![1, 2, 3, 4, 5]);
        }

        #[test]
        fn test_heap_reverse_sorted_input() {
            let mut heap = MinHeap::new();
            for v in [5, 4, 3, 2, 1] {
                heap.push(v);
            }
            let mut result = Vec::new();
            while let Some(v) = heap.pop() {
                result.push(v);
            }
            assert_eq!(result, vec![1, 2, 3, 4, 5]);
        }

        #[test]
        fn test_heap_duplicates() {
            let mut heap = MinHeap::new();
            for v in [3, 1, 3, 1, 2] {
                heap.push(v);
            }
            let mut result = Vec::new();
            while let Some(v) = heap.pop() {
                result.push(v);
            }
            assert_eq!(result, vec![1, 1, 2, 3, 3]);
        }
    }
}
