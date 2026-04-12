# Ruby アルゴリズム実装

Python 版を基に Ruby 版として展開したアルゴリズムとデータ構造の TDD 実装集です。

## セットアップ

```bash
cd apps/ruby
bundle install
```

## テスト実行

```bash
bundle exec rspec
```

## 構造

```
apps/ruby/
├── Gemfile              # 依存関係
├── .rspec               # RSpec 設定
├── lib/
│   └── algorithm/       # アルゴリズム実装
│       ├── basic_algorithms.rb
│       ├── arrays.rb
│       ├── search.rb
│       ├── stack_queue.rb
│       ├── recursion.rb
│       ├── sort.rb
│       ├── strings.rb
│       ├── linked_list.rb
│       └── tree.rb
└── spec/
    ├── spec_helper.rb
    ├── basic_algorithms_spec.rb
    ├── arrays_spec.rb
    ├── search_spec.rb
    ├── stack_queue_spec.rb
    ├── recursion_spec.rb
    ├── sort_spec.rb
    ├── strings_spec.rb
    ├── linked_list_spec.rb
    └── tree_spec.rb
```
