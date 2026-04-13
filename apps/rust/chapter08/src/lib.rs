// chapter08: リスト（連結リスト）

// =============================================================================
// 1. 単方向連結リスト（LinkedList）
// =============================================================================

type Link<T> = Option<Box<Node<T>>>;

#[derive(Debug)]
struct Node<T> {
    data: T,
    next: Link<T>,
}

/// 線形リスト（単方向連結リスト）
#[derive(Debug)]
pub struct LinkedList<T> {
    head: Link<T>,
    size: usize,
}

impl<T: PartialEq + Clone + std::fmt::Debug> LinkedList<T> {
    /// 空のリストを生成する
    pub fn new() -> Self {
        LinkedList {
            head: None,
            size: 0,
        }
    }

    /// リストが空か判定する
    pub fn is_empty(&self) -> bool {
        self.head.is_none()
    }

    /// 要素数を返す
    pub fn len(&self) -> usize {
        self.size
    }

    /// 先頭にノードを挿入する
    pub fn push_front(&mut self, data: T) {
        let new_node = Box::new(Node {
            data,
            next: self.head.take(),
        });
        self.head = Some(new_node);
        self.size += 1;
    }

    /// 末尾にノードを挿入する
    pub fn push_back(&mut self, data: T) {
        let new_node = Box::new(Node {
            data,
            next: None,
        });
        if self.head.is_none() {
            self.head = Some(new_node);
        } else {
            let mut ptr = self.head.as_mut().unwrap();
            while ptr.next.is_some() {
                ptr = ptr.next.as_mut().unwrap();
            }
            ptr.next = Some(new_node);
        }
        self.size += 1;
    }

    /// 先頭ノードを削除して値を返す
    pub fn pop_front(&mut self) -> Option<T> {
        self.head.take().map(|node| {
            self.head = node.next;
            self.size -= 1;
            node.data
        })
    }

    /// 末尾ノードを削除して値を返す
    pub fn pop_back(&mut self) -> Option<T> {
        if self.head.is_none() {
            return None;
        }
        // ノードが 1 つだけの場合
        if self.head.as_ref().unwrap().next.is_none() {
            return self.pop_front();
        }
        // 末尾の 1 つ前まで辿る
        let mut ptr = self.head.as_mut().unwrap();
        while ptr.next.as_ref().unwrap().next.is_some() {
            ptr = ptr.next.as_mut().unwrap();
        }
        let tail = ptr.next.take().unwrap();
        self.size -= 1;
        Some(tail.data)
    }

    /// 指定した値を探索する
    pub fn search(&self, data: &T) -> bool {
        let mut ptr = &self.head;
        while let Some(node) = ptr {
            if &node.data == data {
                return true;
            }
            ptr = &node.next;
        }
        false
    }

    /// 指定した値を持つ最初のノードを削除する
    pub fn remove(&mut self, data: &T) -> bool {
        // 先頭ノードの場合
        if let Some(ref node) = self.head {
            if &node.data == data {
                self.pop_front();
                return true;
            }
        }
        // 2 番目以降を探索
        let mut ptr = self.head.as_mut();
        while let Some(node) = ptr {
            if let Some(ref next_node) = node.next {
                if &next_node.data == data {
                    let removed = node.next.take().unwrap();
                    node.next = removed.next;
                    self.size -= 1;
                    return true;
                }
            }
            ptr = node.next.as_mut();
        }
        false
    }

    /// 全ノードを削除する
    pub fn clear(&mut self) {
        // ドロップを逐次的に行い、スタックオーバーフローを防ぐ
        while self.pop_front().is_some() {}
    }

    /// テスト用: リストの要素を Vec に変換する
    pub fn to_vec(&self) -> Vec<T> {
        let mut result = Vec::new();
        let mut ptr = &self.head;
        while let Some(node) = ptr {
            result.push(node.data.clone());
            ptr = &node.next;
        }
        result
    }
}

// =============================================================================
// 2. 双方向連結リスト（DoublyLinkedList）
// =============================================================================

use std::cell::RefCell;
use std::rc::Rc;

type DLink<T> = Option<Rc<RefCell<DNode<T>>>>;

#[derive(Debug)]
struct DNode<T> {
    data: T,
    prev: DLink<T>,
    next: DLink<T>,
}

/// 循環・双方向連結リスト（番兵ノード使用）
pub struct DoublyLinkedList<T> {
    /// 番兵ノード: sentinel.next が先頭、sentinel.prev が末尾
    sentinel: Rc<RefCell<DNode<T>>>,
    size: usize,
}

impl<T: PartialEq + Clone + std::fmt::Debug + Default> DoublyLinkedList<T> {
    /// 空のリストを生成する（番兵ノードを配置）
    pub fn new() -> Self {
        let sentinel = Rc::new(RefCell::new(DNode {
            data: T::default(),
            prev: None,
            next: None,
        }));
        // 番兵の prev, next を自分自身に向ける（循環）
        sentinel.borrow_mut().prev = Some(Rc::clone(&sentinel));
        sentinel.borrow_mut().next = Some(Rc::clone(&sentinel));
        DoublyLinkedList { sentinel, size: 0 }
    }

    /// リストが空か判定する
    pub fn is_empty(&self) -> bool {
        self.size == 0
    }

    /// 要素数を返す
    pub fn len(&self) -> usize {
        self.size
    }

    /// 先頭にノードを挿入する
    pub fn push_front(&mut self, data: T) {
        let new_node = Rc::new(RefCell::new(DNode {
            data,
            prev: Some(Rc::clone(&self.sentinel)),
            next: None,
        }));
        // old_first = sentinel.next
        let old_first = self.sentinel.borrow().next.as_ref().unwrap().clone();
        new_node.borrow_mut().next = Some(Rc::clone(&old_first));
        old_first.borrow_mut().prev = Some(Rc::clone(&new_node));
        self.sentinel.borrow_mut().next = Some(new_node);
        self.size += 1;
    }

    /// 末尾にノードを挿入する
    pub fn push_back(&mut self, data: T) {
        let new_node = Rc::new(RefCell::new(DNode {
            data,
            prev: None,
            next: Some(Rc::clone(&self.sentinel)),
        }));
        // old_last = sentinel.prev
        let old_last = self.sentinel.borrow().prev.as_ref().unwrap().clone();
        new_node.borrow_mut().prev = Some(Rc::clone(&old_last));
        old_last.borrow_mut().next = Some(Rc::clone(&new_node));
        self.sentinel.borrow_mut().prev = Some(new_node);
        self.size += 1;
    }

    /// 指定した値を探索する
    pub fn search(&self, data: &T) -> bool {
        let mut current = self.sentinel.borrow().next.as_ref().unwrap().clone();
        loop {
            if Rc::ptr_eq(&current, &self.sentinel) {
                return false;
            }
            if &current.borrow().data == data {
                return true;
            }
            let next = current.borrow().next.as_ref().unwrap().clone();
            current = next;
        }
    }

    /// 指定した値を持つ最初のノードを削除する
    pub fn remove(&mut self, data: &T) -> bool {
        if self.is_empty() {
            return false;
        }
        let mut current = self.sentinel.borrow().next.as_ref().unwrap().clone();
        loop {
            if Rc::ptr_eq(&current, &self.sentinel) {
                return false;
            }
            if &current.borrow().data == data {
                // current を外す: prev.next = current.next, next.prev = current.prev
                let prev = current.borrow().prev.as_ref().unwrap().clone();
                let next = current.borrow().next.as_ref().unwrap().clone();
                prev.borrow_mut().next = Some(Rc::clone(&next));
                next.borrow_mut().prev = Some(Rc::clone(&prev));
                self.size -= 1;
                return true;
            }
            let next = current.borrow().next.as_ref().unwrap().clone();
            current = next;
        }
    }

    /// 全ノードを削除する
    pub fn clear(&mut self) {
        self.sentinel.borrow_mut().next = Some(Rc::clone(&self.sentinel));
        self.sentinel.borrow_mut().prev = Some(Rc::clone(&self.sentinel));
        self.size = 0;
    }

    /// テスト用: リストの要素を Vec に変換する
    pub fn to_vec(&self) -> Vec<T> {
        let mut result = Vec::new();
        let mut current = self.sentinel.borrow().next.as_ref().unwrap().clone();
        loop {
            if Rc::ptr_eq(&current, &self.sentinel) {
                break;
            }
            result.push(current.borrow().data.clone());
            let next = current.borrow().next.as_ref().unwrap().clone();
            current = next;
        }
        result
    }
}

// =============================================================================
// 3. 配列カーソル版リスト（ArrayLinkedList）
// =============================================================================

const NULL: usize = usize::MAX;

/// 配列カーソル版リストのノード
#[derive(Debug, Clone)]
struct ArrayNode {
    data: Option<i32>,
    next: usize,  // 次のインデックス（NULL = 末尾）
    dnext: usize, // フリーリストの next
}

impl ArrayNode {
    fn new() -> Self {
        ArrayNode {
            data: None,
            next: NULL,
            dnext: NULL,
        }
    }

    fn with_data(data: i32, next: usize) -> Self {
        ArrayNode {
            data: Some(data),
            next,
            dnext: NULL,
        }
    }
}

/// 線形リストクラス（配列カーソル版）
pub struct ArrayLinkedList {
    n: Vec<ArrayNode>,
    head: usize,
    current: usize,
    max: usize,     // 使用済み最大インデックス（未使用時は NULL）
    deleted: usize,  // フリーリストの先頭
    capacity: usize,
    size: usize,
}

impl ArrayLinkedList {
    /// 指定容量で空のリストを生成する
    pub fn new(capacity: usize) -> Self {
        ArrayLinkedList {
            n: vec![ArrayNode::new(); capacity],
            head: NULL,
            current: NULL,
            max: NULL,
            deleted: NULL,
            capacity,
            size: 0,
        }
    }

    /// 要素数を返す
    pub fn len(&self) -> usize {
        self.size
    }

    /// 次に挿入するレコードの添字を求める
    fn get_insert_index(&mut self) -> usize {
        if self.deleted == NULL {
            let next_max = if self.max == NULL { 0 } else { self.max + 1 };
            if next_max < self.capacity {
                self.max = next_max;
                self.max
            } else {
                NULL // 満杯
            }
        } else {
            let rec = self.deleted;
            self.deleted = self.n[rec].dnext;
            rec
        }
    }

    /// 先頭にノードを挿入する
    pub fn add_first(&mut self, data: i32) {
        let ptr = self.head;
        let rec = self.get_insert_index();
        if rec != NULL {
            self.head = rec;
            self.current = rec;
            self.n[rec] = ArrayNode::with_data(data, ptr);
            self.size += 1;
        }
    }

    /// 末尾にノードを挿入する
    pub fn add_last(&mut self, data: i32) {
        if self.head == NULL {
            self.add_first(data);
        } else {
            let mut ptr = self.head;
            while self.n[ptr].next != NULL {
                ptr = self.n[ptr].next;
            }
            let rec = self.get_insert_index();
            if rec != NULL {
                self.n[ptr].next = rec;
                self.current = rec;
                self.n[rec] = ArrayNode::with_data(data, NULL);
                self.size += 1;
            }
        }
    }

    /// 指定した値を探索し、インデックスを返す。見つからなければ NULL
    pub fn search(&mut self, data: i32) -> usize {
        let mut ptr = self.head;
        while ptr != NULL {
            if self.n[ptr].data == Some(data) {
                self.current = ptr;
                return ptr;
            }
            ptr = self.n[ptr].next;
        }
        NULL
    }

    /// 先頭ノードを削除する
    pub fn remove_first(&mut self) {
        if self.head != NULL {
            let ptr = self.head;
            self.head = self.n[ptr].next;
            self.current = self.head;
            self.n[ptr].dnext = self.deleted;
            self.deleted = ptr;
            self.size -= 1;
        }
    }

    /// 指定したインデックスのノードのデータを返す
    pub fn get_data(&self, idx: usize) -> Option<i32> {
        if idx < self.capacity {
            self.n[idx].data
        } else {
            None
        }
    }

    /// head インデックスを返す（テスト用）
    pub fn head_index(&self) -> usize {
        self.head
    }
}

// =============================================================================
// テスト
// =============================================================================

#[cfg(test)]
mod tests {
    use super::*;

    // =========================================================================
    // 単方向連結リスト（LinkedList）テスト
    // =========================================================================

    mod linked_list_tests {
        use super::*;

        #[test]
        fn test_initial_empty() {
            let lst: LinkedList<i32> = LinkedList::new();
            assert_eq!(lst.len(), 0);
            assert!(lst.is_empty());
        }

        #[test]
        fn test_push_front() {
            let mut lst = LinkedList::new();
            lst.push_front(1);
            assert_eq!(lst.len(), 1);
            lst.push_front(2);
            assert_eq!(lst.len(), 2);
            // 先頭に追加なので 2 -> 1 の順
            assert_eq!(lst.to_vec(), vec![2, 1]);
        }

        #[test]
        fn test_push_back() {
            let mut lst = LinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            assert_eq!(lst.len(), 2);
            assert_eq!(lst.to_vec(), vec![1, 2]);
        }

        #[test]
        fn test_pop_front() {
            let mut lst = LinkedList::new();
            lst.push_back(10);
            lst.push_back(20);
            lst.push_back(30);
            assert_eq!(lst.pop_front(), Some(10));
            assert_eq!(lst.len(), 2);
            assert_eq!(lst.pop_front(), Some(20));
            assert_eq!(lst.pop_front(), Some(30));
            assert_eq!(lst.pop_front(), None);
        }

        #[test]
        fn test_pop_back() {
            let mut lst = LinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.push_back(3);
            assert_eq!(lst.pop_back(), Some(3));
            assert_eq!(lst.len(), 2);
            assert_eq!(lst.pop_back(), Some(2));
            assert_eq!(lst.pop_back(), Some(1));
            assert_eq!(lst.pop_back(), None);
        }

        #[test]
        fn test_search_found() {
            let mut lst = LinkedList::new();
            lst.push_back(10);
            lst.push_back(20);
            lst.push_back(30);
            assert!(lst.search(&20));
        }

        #[test]
        fn test_search_not_found() {
            let mut lst = LinkedList::new();
            lst.push_back(10);
            assert!(!lst.search(&99));
        }

        #[test]
        fn test_remove_found() {
            let mut lst = LinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.push_back(3);
            assert!(lst.remove(&2));
            assert!(!lst.search(&2));
            assert_eq!(lst.len(), 2);
            assert_eq!(lst.to_vec(), vec![1, 3]);
        }

        #[test]
        fn test_remove_head() {
            let mut lst = LinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            assert!(lst.remove(&1));
            assert_eq!(lst.to_vec(), vec![2]);
        }

        #[test]
        fn test_remove_not_found() {
            let mut lst = LinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            assert!(!lst.remove(&99));
            assert_eq!(lst.len(), 2);
        }

        #[test]
        fn test_remove_from_empty() {
            let mut lst: LinkedList<i32> = LinkedList::new();
            assert!(!lst.remove(&1));
        }

        #[test]
        fn test_clear() {
            let mut lst = LinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.push_back(3);
            lst.clear();
            assert!(lst.is_empty());
            assert_eq!(lst.len(), 0);
        }

        #[test]
        fn test_to_vec() {
            let mut lst = LinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.push_back(3);
            assert_eq!(lst.to_vec(), vec![1, 2, 3]);
        }

        #[test]
        fn test_pop_front_empty() {
            let mut lst: LinkedList<i32> = LinkedList::new();
            assert_eq!(lst.pop_front(), None);
        }

        #[test]
        fn test_pop_back_single() {
            let mut lst = LinkedList::new();
            lst.push_back(42);
            assert_eq!(lst.pop_back(), Some(42));
            assert!(lst.is_empty());
        }

        #[test]
        fn test_remove_last_element() {
            let mut lst = LinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.push_back(3);
            assert!(lst.remove(&3));
            assert_eq!(lst.to_vec(), vec![1, 2]);
        }
    }

    // =========================================================================
    // 双方向連結リスト（DoublyLinkedList）テスト
    // =========================================================================

    mod doubly_linked_list_tests {
        use super::*;

        #[test]
        fn test_initial_empty() {
            let lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            assert_eq!(lst.len(), 0);
            assert!(lst.is_empty());
        }

        #[test]
        fn test_push_front() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_front(1);
            assert_eq!(lst.len(), 1);
            lst.push_front(2);
            assert_eq!(lst.len(), 2);
            assert_eq!(lst.to_vec(), vec![2, 1]);
        }

        #[test]
        fn test_push_back() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            assert_eq!(lst.len(), 2);
            assert_eq!(lst.to_vec(), vec![1, 2]);
        }

        #[test]
        fn test_search_found() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_back(10);
            lst.push_back(20);
            lst.push_back(30);
            assert!(lst.search(&20));
        }

        #[test]
        fn test_search_not_found() {
            let lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            assert!(!lst.search(&99));
        }

        #[test]
        fn test_remove() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.push_back(3);
            assert!(lst.remove(&2));
            assert!(!lst.search(&2));
            assert_eq!(lst.len(), 2);
            assert_eq!(lst.to_vec(), vec![1, 3]);
        }

        #[test]
        fn test_remove_from_empty() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            assert!(!lst.remove(&1));
        }

        #[test]
        fn test_remove_not_found() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_back(1);
            assert!(!lst.remove(&99));
        }

        #[test]
        fn test_clear() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.clear();
            assert!(lst.is_empty());
            assert_eq!(lst.len(), 0);
        }

        #[test]
        fn test_to_vec() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.push_back(3);
            assert_eq!(lst.to_vec(), vec![1, 2, 3]);
        }

        #[test]
        fn test_push_front_and_back_mixed() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_back(2);
            lst.push_front(1);
            lst.push_back(3);
            assert_eq!(lst.to_vec(), vec![1, 2, 3]);
        }

        #[test]
        fn test_remove_first_element() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.push_back(3);
            assert!(lst.remove(&1));
            assert_eq!(lst.to_vec(), vec![2, 3]);
        }

        #[test]
        fn test_remove_last_element() {
            let mut lst: DoublyLinkedList<i32> = DoublyLinkedList::new();
            lst.push_back(1);
            lst.push_back(2);
            lst.push_back(3);
            assert!(lst.remove(&3));
            assert_eq!(lst.to_vec(), vec![1, 2]);
        }
    }

    // =========================================================================
    // 配列カーソル版リスト（ArrayLinkedList）テスト
    // =========================================================================

    mod array_linked_list_tests {
        use super::*;

        #[test]
        fn test_initial_empty() {
            let lst = ArrayLinkedList::new(100);
            assert_eq!(lst.len(), 0);
        }

        #[test]
        fn test_add_first() {
            let mut lst = ArrayLinkedList::new(100);
            lst.add_first(1);
            assert_eq!(lst.len(), 1);
            lst.add_first(2);
            assert_eq!(lst.len(), 2);
        }

        #[test]
        fn test_add_first_order() {
            let mut lst = ArrayLinkedList::new(100);
            lst.add_first(1);
            lst.add_first(2);
            lst.add_first(3);
            // head から辿ると 3 -> 2 -> 1 の順
            assert_eq!(lst.get_data(lst.head_index()), Some(3));
        }

        #[test]
        fn test_add_last() {
            let mut lst = ArrayLinkedList::new(100);
            lst.add_last(1);
            assert_eq!(lst.len(), 1);
            lst.add_last(2);
            assert_eq!(lst.len(), 2);
        }

        #[test]
        fn test_add_last_order() {
            let mut lst = ArrayLinkedList::new(100);
            lst.add_last(1);
            lst.add_last(2);
            lst.add_last(3);
            // head から辿ると 1 -> 2 -> 3 の順
            assert_eq!(lst.get_data(lst.head_index()), Some(1));
        }

        #[test]
        fn test_search_found() {
            let mut lst = ArrayLinkedList::new(100);
            lst.add_last(10);
            lst.add_last(20);
            lst.add_last(30);
            let idx = lst.search(20);
            assert_ne!(idx, NULL);
            assert_eq!(lst.get_data(idx), Some(20));
        }

        #[test]
        fn test_search_not_found() {
            let mut lst = ArrayLinkedList::new(100);
            lst.add_last(10);
            assert_eq!(lst.search(99), NULL);
        }

        #[test]
        fn test_remove_first() {
            let mut lst = ArrayLinkedList::new(100);
            lst.add_last(1);
            lst.add_last(2);
            lst.add_last(3);
            lst.remove_first();
            assert_eq!(lst.len(), 2);
            assert_eq!(lst.search(1), NULL);
        }

        #[test]
        fn test_remove_first_empty() {
            let mut lst = ArrayLinkedList::new(100);
            lst.remove_first();
            assert_eq!(lst.len(), 0);
        }

        #[test]
        fn test_reuse_deleted_slot() {
            let mut lst = ArrayLinkedList::new(100);
            lst.add_first(1);
            lst.add_first(2);
            lst.remove_first();
            lst.add_first(3);
            assert_eq!(lst.len(), 2);
        }

        #[test]
        fn test_capacity_exceeded() {
            let mut lst = ArrayLinkedList::new(2);
            lst.add_first(1);
            lst.add_first(2);
            // capacity=2 に達しているので挿入されない
            lst.add_first(3);
            assert_eq!(lst.len(), 2);
        }
    }
}
