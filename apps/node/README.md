# algorithm-node

アルゴリズムとデータ構造を TypeScript で TDD しながら学ぶ

## セットアップ

```bash
cd apps/node
npm install
```

## コマンド

```bash
# テスト実行
npm test

# カバレッジ付きテスト
npm run test:coverage

# 型チェック
npm run build

# Lint
npm run lint

# 全チェック
npm run check
```

## 構成

```
apps/node/
├── src/
│   └── algorithm/      # アルゴリズム実装
├── tests/              # テストファイル
├── jest.config.js
├── tsconfig.json
└── package.json
```
