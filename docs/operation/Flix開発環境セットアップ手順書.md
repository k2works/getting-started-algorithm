# Flix アプリケーション開発環境セットアップ手順書

## 概要

本書では、`getting-started-algorithm` の Flix アルゴリズム教材を実行するローカル開発環境を構築します。Flix 0.75.1 と JDK 21 を使用し、Flix の標準テスト・型検査・フォーマッターを実行します。

## 1. 前提条件

- Windows の場合は WSL2 と Ubuntu を使用します。Nix は Windows ネイティブ環境ではなく、WSL 内で実行してください。
- Nix が有効になっていることを確認します。

```bash
nix --version
```

このリポジトリには Flix の Nix 開発シェルが定義されています。シェルに入ると JDK 21 と GNU Make が利用可能になります。

## 2. Flix 開発環境の起動

リポジトリのルートディレクトリで実行します。

```bash
nix develop path:.#flix
```

シェル内でバージョンを確認します。

```bash
javac -version
make --version
```

## 3. Flix の取得

Flix のバージョンは `apps/flix/flix.toml` で固定します。JAR はリポジトリに登録せず、GitHub Releases から取得します。

```bash
cd apps/flix
version="$(sed -n 's/^flix[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' flix.toml)"
curl -fL --retry 2 \
  -o flix.jar \
  "https://github.com/flix/flix/releases/download/v${version}/flix.jar"
```

JAR は `apps/flix/.gitignore` で除外されます。バージョンを更新する場合は、`flix.toml` と Nix 開発シェルのバージョンもそろえてください。

## 4. テストと品質検査

```bash
make test
make check
make format-check
```

`make test` は Flix の `@Test` を実行します。`make check` は型・効果検査を行い、`make format-check` は Flix 0.75.1 に `format --check` オプションがないため、一時コピーを整形して元のソースと差分がないことを確認します。ソースを整形する場合は `make format` を実行します。

## 5. トラブルシューティング

### `nix develop path:.#flix` で flake が無効と表示される

Nix の experimental features を有効にして再実行します。

```bash
nix --extra-experimental-features "nix-command flakes" develop path:.#flix
```

### Flix の JAR が見つからない

`apps/flix` ディレクトリで、手順 3 のダウンロードコマンドを実行してください。ネットワーク接続と `flix.toml` のバージョンを確認します。

### WSL 内にリポジトリがない

WSL の Linux ファイルシステム上にリポジトリを clone し、clone 先で Nix コマンドを実行してください。Windows ドライブ上のリポジトリを利用する場合は `/mnt/c/...` のパスを使用できますが、I/O が遅くなる場合があります。
