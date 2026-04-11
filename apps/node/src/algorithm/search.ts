/**
 * 第3章 探索アルゴリズム
 */

/** シーケンスからkeyと等価な要素を線形探索（while文）*/
export function ssearchWhile<T>(a: T[], key: T): number {
  let i = 0;
  while (true) {
    if (i === a.length) return -1;
    if (a[i] === key) return i;
    i++;
  }
}

/** シーケンスからkeyと等価な要素を線形探索（for文）*/
export function ssearchFor<T>(a: T[], key: T): number {
  for (let i = 0; i < a.length; i++) {
    if (a[i] === key) return i;
  }
  return -1;
}

/** シーケンスからkeyと一致する要素を線形探索（番兵法）*/
export function ssearchSentinel<T>(seq: T[], key: T): number {
  const a = [...seq, key]; // 番兵を追加
  let i = 0;
  while (true) {
    if (a[i] === key) break;
    i++;
  }
  return i === seq.length ? -1 : i;
}

/** ソート済み配列からkeyと一致する要素を二分探索 */
export function bsearch<T>(a: T[], key: T): number {
  let pl = 0;
  let pr = a.length - 1;

  while (true) {
    const pc = Math.floor((pl + pr) / 2);
    if (a[pc] === key) return pc;
    else if (a[pc] < key) pl = pc + 1;
    else pr = pc - 1;
    if (pl > pr) break;
  }
  return -1;
}

// ─── チェイン法ハッシュ ───────────────────────────────────

class Node<K, V> {
  constructor(
    public key: K,
    public value: V,
    public next: Node<K, V> | null,
  ) {}
}

/** チェイン法を実現するハッシュクラス */
export class ChainedHash<K, V> {
  private table: Array<Node<K, V> | null>;

  constructor(private capacity: number) {
    this.table = new Array(capacity).fill(null);
  }

  private hashValue(key: K): number {
    if (typeof key === 'number') return (key as number) % this.capacity;
    let hash = 0;
    const str = String(key);
    for (let i = 0; i < str.length; i++) {
      hash = (hash * 31 + str.charCodeAt(i)) % this.capacity;
    }
    return hash;
  }

  search(key: K): V | null {
    const h = this.hashValue(key);
    let p = this.table[h];
    while (p !== null) {
      if (p.key === key) return p.value;
      p = p.next;
    }
    return null;
  }

  add(key: K, value: V): boolean {
    const h = this.hashValue(key);
    let p = this.table[h];
    while (p !== null) {
      if (p.key === key) return false;
      p = p.next;
    }
    this.table[h] = new Node(key, value, this.table[h]);
    return true;
  }

  remove(key: K): boolean {
    const h = this.hashValue(key);
    let p = this.table[h];
    let pp: Node<K, V> | null = null;
    while (p !== null) {
      if (p.key === key) {
        if (pp === null) this.table[h] = p.next;
        else pp.next = p.next;
        return true;
      }
      pp = p;
      p = p.next;
    }
    return false;
  }
}

// ─── オープンアドレス法ハッシュ ──────────────────────────

const enum BucketStatus {
  OCCUPIED,
  EMPTY,
  DELETED,
}

class Bucket<K, V> {
  constructor(
    public key: K | null = null,
    public value: V | null = null,
    public stat: BucketStatus = BucketStatus.EMPTY,
  ) {}
}

/** オープンアドレス法（線形探索法）を実現するハッシュクラス */
export class OpenHash<K, V> {
  private table: Bucket<K, V>[];

  constructor(private capacity: number) {
    this.table = Array.from({ length: capacity }, () => new Bucket());
  }

  private hashValue(key: K): number {
    if (typeof key === 'number') return (key as number) % this.capacity;
    let hash = 0;
    const str = String(key);
    for (let i = 0; i < str.length; i++) {
      hash = (hash * 31 + str.charCodeAt(i)) % this.capacity;
    }
    return hash;
  }

  search(key: K): V | null {
    let h = this.hashValue(key);
    for (let i = 0; i < this.capacity; i++) {
      const p = this.table[h];
      if (p.stat === BucketStatus.EMPTY) break;
      if (p.stat === BucketStatus.OCCUPIED && p.key === key) return p.value;
      h = (h + 1) % this.capacity;
    }
    return null;
  }

  add(key: K, value: V): boolean {
    if (this.search(key) !== null) return false;
    let h = this.hashValue(key);
    for (let i = 0; i < this.capacity; i++) {
      const p = this.table[h];
      if (p.stat === BucketStatus.EMPTY || p.stat === BucketStatus.DELETED) {
        this.table[h] = new Bucket(key, value, BucketStatus.OCCUPIED);
        return true;
      }
      h = (h + 1) % this.capacity;
    }
    return false;
  }

  remove(key: K): boolean {
    let h = this.hashValue(key);
    for (let i = 0; i < this.capacity; i++) {
      const p = this.table[h];
      if (p.stat === BucketStatus.EMPTY) return false;
      if (p.stat === BucketStatus.OCCUPIED && p.key === key) {
        p.stat = BucketStatus.DELETED;
        return true;
      }
      h = (h + 1) % this.capacity;
    }
    return false;
  }
}
