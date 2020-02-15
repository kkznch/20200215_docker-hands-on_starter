# 「tech美られでぃ #4 Docker どっか〜ん！（初心者向け）」用リポジトリ

## 概要

[tech美られでぃ #4 Docker どっか〜ん！（初心者向け）](https://tech-chura-lady.connpass.com/event/163133) のハンズオンで必要なファイルとか置いてます。

Docker や Docker Compose に関連するファイルは含まれていないので、手を動かして自分で作っていきましょう。

## リポジトリの中にある奴

- `README.md`
  - README です。ハンズオンの手順とかこっちに書いていきます。
- `Makefile`
  - Makefile です。アプリの初期処理をする際に使います。
- `conf.d/nginx/default.conf`
  - nginx の Docker コンテナに差し込む設定ファイルです。
- `local-app`
  - Laravel がたくさん詰まったフォルダです。

## ハンズオンやること目次

1. Docker の操作的なハンズオン
    1. 最小限の Dockerfile を書く
    2. docker コマンドで Dockerfile からイメージを作成する
    3. docker コマンドで作成したイメージを確認する
    4. docker コマンドで作成したイメージからコンテナを起動する
    5. docker コマンドでコンテナの停止、再度起動する
2.  Dockerfile を書いていくハンズオン
    1. dokcer コマンドでコンテナを起動しログインする
    2. 必要なパッケージをインストールしていく（あらかじめこちらから提示しておく）
    3. パッケージのインストールが確認できたら Dockerfile に記述していく
    4. Dockerfile からイメージを再度作成する
3. docker-compose なハンズオン
    1. docker-compose.yml を書いていく
    2. docker-compose コマンドで起動する

## ハンズオンする

