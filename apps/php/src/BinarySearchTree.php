<?php

declare(strict_types=1);

namespace Algorithm;

/**
 * 第9章 木構造
 */
class BSTNode
{
    public function __construct(
        public mixed    $key,
        public ?BSTNode $left  = null,
        public ?BSTNode $right = null,
    ) {}
}

class BinarySearchTree
{
    private ?BSTNode $root = null;
    private int      $size = 0;

    public function insert(mixed $key): void
    {
        $this->root = $this->insertNode($this->root, $key);
    }

    private function insertNode(?BSTNode $node, mixed $key): BSTNode
    {
        if ($node === null) {
            $this->size++;
            return new BSTNode($key);
        }
        if ($key < $node->key) {
            $node->left = $this->insertNode($node->left, $key);
        } elseif ($key > $node->key) {
            $node->right = $this->insertNode($node->right, $key);
        }
        // 重複は無視
        return $node;
    }

    public function search(mixed $key): ?BSTNode
    {
        return $this->searchNode($this->root, $key);
    }

    private function searchNode(?BSTNode $node, mixed $key): ?BSTNode
    {
        if ($node === null) {
            return null;
        }
        if ($key === $node->key) {
            return $node;
        }
        if ($key < $node->key) {
            return $this->searchNode($node->left, $key);
        }
        return $this->searchNode($node->right, $key);
    }

    public function includes(mixed $key): bool
    {
        return $this->search($key) !== null;
    }

    public function length(): int
    {
        return $this->size;
    }

    /** 最小値 */
    public function min(): mixed
    {
        if ($this->root === null) {
            throw new \UnderflowException('Tree is empty');
        }
        return $this->minNode($this->root)->key;
    }

    private function minNode(BSTNode $node): BSTNode
    {
        while ($node->left !== null) {
            $node = $node->left;
        }
        return $node;
    }

    /** 最大値 */
    public function max(): mixed
    {
        if ($this->root === null) {
            throw new \UnderflowException('Tree is empty');
        }
        $node = $this->root;
        while ($node->right !== null) {
            $node = $node->right;
        }
        return $node->key;
    }

    /** 中順探索（昇順） */
    public function inorder(): array
    {
        $result = [];
        $this->inorderTraverse($this->root, $result);
        return $result;
    }

    private function inorderTraverse(?BSTNode $node, array &$result): void
    {
        if ($node === null) {
            return;
        }
        $this->inorderTraverse($node->left, $result);
        $result[] = $node->key;
        $this->inorderTraverse($node->right, $result);
    }

    /** 前順探索 */
    public function preorder(): array
    {
        $result = [];
        $this->preorderTraverse($this->root, $result);
        return $result;
    }

    private function preorderTraverse(?BSTNode $node, array &$result): void
    {
        if ($node === null) {
            return;
        }
        $result[] = $node->key;
        $this->preorderTraverse($node->left, $result);
        $this->preorderTraverse($node->right, $result);
    }

    /** 後順探索 */
    public function postorder(): array
    {
        $result = [];
        $this->postorderTraverse($this->root, $result);
        return $result;
    }

    private function postorderTraverse(?BSTNode $node, array &$result): void
    {
        if ($node === null) {
            return;
        }
        $this->postorderTraverse($node->left, $result);
        $this->postorderTraverse($node->right, $result);
        $result[] = $node->key;
    }

    /** ノード削除 */
    public function delete(mixed $key): void
    {
        $this->root = $this->deleteNode($this->root, $key);
    }

    private function deleteNode(?BSTNode $node, mixed $key): ?BSTNode
    {
        if ($node === null) {
            return null;
        }
        if ($key < $node->key) {
            $node->left = $this->deleteNode($node->left, $key);
        } elseif ($key > $node->key) {
            $node->right = $this->deleteNode($node->right, $key);
        } else {
            // 削除対象ノード
            $this->size--;
            if ($node->left === null) {
                return $node->right;
            }
            if ($node->right === null) {
                return $node->left;
            }
            // 子が2つ: 右部分木の最小値で置き換える
            $min         = $this->minNode($node->right);
            $node->key   = $min->key;
            $this->size++; // deleteNode 内で再び --size されるので補正
            $node->right = $this->deleteNode($node->right, $min->key);
        }
        return $node;
    }
}
