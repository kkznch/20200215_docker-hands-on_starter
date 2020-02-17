# 「tech美られでぃ #4 Docker どっか〜ん！（初心者向け）」用リポジトリ

## 概要

[tech美られでぃ #4 Docker どっか〜ん！（初心者向け）](https://tech-chura-lady.connpass.com/event/163133) のハンズオンで必要なファイルとか置いてます。
Docker や Docker Compose に関連するファイルは含まれていないので、手を動かして自分で作っていきましょう。

完成版が欲しい人は以下のリポジトリをどうぞー。

https://github.com/kkznch/20200215_docker-hands-on_completed


## リポジトリの中にある奴

- `README.md`
  - README です。ハンズオンの手順とかこっちに書いていきます。
- `Makefile`
  - Makefile です。アプリの初期処理をする際に使います。
- `conf.d/nginx/default.conf`
  - nginx の Docker コンテナに差し込む設定ファイルです。
- `local-app`
  - Laravel がたくさん詰まったフォルダです。

## こんな感じのもの作るよ

![20200215_Dockerハンズオン](https://user-images.githubusercontent.com/1622387/74581705-bb872700-4ff5-11ea-8abc-8616718bcde6.png)

## ハンズオンやること目次

1. Docker の操作的なハンズオン
    1. 最小限の Dockerfile を書く
    2. Dockerfile からイメージを作成する
    3. 作成したイメージからコンテナを起動する
2.  Dockerfile を書いていくハンズオン
    1. コンテナを起動しログインする
    2. 必要なパッケージをインストールしていく
    3. パッケージのインストールが確認できたら Dockerfile に記述していく
    4. Dockerfile からイメージを作成できることを確認する
3. docker-compose なハンズオン
    1. docker-compose.yml を書いていく
    2. docker-compose コマンドで起動する

## ハンズオンするぞ！

まずは Terminal を開いて好きな場所でこのリポジトリを clone するのだ。
リポジトリの名前が長いので別名を付けても良いよ。

```shell
$ git clone https://github.com/kkznch/20200215_docker-hands-on_starter.git
```

そしてフォルダの中に移動する。

```shell
$ cd 20200215_docker-hands-on_starter
```

これで全ての準備は整った。

### Docker の操作的なハンズオン

1. まずは最小限の Dockerfile を書こう
    ```Dockerfile
    FROM alpine
  
    RUN echo "Docker のビルド中..."
  
    CMD echo "Docker 起動したよ！やったね！"
    ```
2. 以下のコマンドで Dockerfile からイメージを作成しよう
    ```shell
    $ docker image build -t my-image .
    ```
    - **Tips:** `docker image build .` だけでもビルドできるけど、作ったイメージの区別がしづらいので `-t タグ名` を付けて実行するのオススメ
3. 以下のコマンドで作成したイメージを確認しよう
    ```shell
    $ docker image ls
  
    REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
    my-image                            latest              a73b017b994d        19 minutes ago      5.59MB
    ```
    - さっきタグ付けしてビルドした `my-image` なイメージがあるね！
4. 以下のコマンドで作成したイメージからコンテナを起動しよう
    ```shell
    $ docker container run my-image
  
    Docker 起動したよ！やったね！
    ```
    - Dockerfile で実行した echo の内容が出力されたので起動できた！
    - このコンテナは echo を実行すると役目を終えて勝手に消えるよ
    - **Tips:** `docker container ls` コマンドで起動してるコンテナの一覧が見えるよ

### Dockerfile を書いていくハンズオン

実務では手順 1, 2 に沿ってコンテナで欲しいパッケージを確認しながら Dockerfile を書いていくのだけど、今回は手順 1 と 2 は飛ばしていいよ。


1. 以下のコマンドでコンテナを起動しログインしよう
    ```shell
    $ docker container run --rm --name my-container -it my-image ash
    ```
    - **Tips:** さっきの `docker container run` コマンドに `--name コンテナ名` をつけることで起動したコンテナの区別が分かりやすくできるよ  
    - **Tips:** `docker container run` コマンドについてる `--rm` オプションは、コンテナを起動して実行した後に自動で消えてくれるようにする設定だよ
2. コンテナの中で必要なパッケージをインストールして確認しよう
    ```shell
    $ apk add パッケージ名
    ```
3. パッケージのインストールが確認できたら Dockerfile に記述していこう（さっきの Dockerfile をまるまる書き換えよう）
    ```Dockerfile
    FROM php:7.3-fpm-alpine

    RUN apk --no-cache update && apk --no-cache upgrade
    RUN docker-php-ext-install bcmath pdo_mysql

    COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
    ```
    - 今回は Laravel アプリを動かすために必要なパッケージとかコマンドをインストールするよ
4. Dockerfile からイメージを作成できるか確認しよう
    ```shell
    $ docker image build -t my-image .
    ```
    - イメージのビルドでエラーが発生しなければ成功！

### docker-compose なハンズオン

Docker コマンドだけで nginx と php-fpm のコンテナを連携させると凄く面倒くさい。
そこで docker-compose を使って楽にコンテナを連携させよう。

1. docker-compose.yml を書いてみよう
    ```yml:docker-compose.yml
    version: '3.7'
    services:
      php-fpm:
        build:
          context: .
          dockerfile: ./Dockerfile
        volumes:
          - ./local-app:/app:cached
        working_dir: /app
      nginx:
        image: nginx:latest
        ports:
          - 80:80
        depends_on:
          - php-fpm
        volumes:
          - ./conf.d/nginx/default.conf:/etc/nginx/conf.d/default.conf
    ```
2. 以下のコマンドで docker-compose.yml に書かれた通りにビルドしよう
    ```shell
    $ docker-compose build
    ```
3. 以下のコマンドでイメージが作られたことを確認しよう
    ```shell
    $ docker image ls
  
    REPOSITORY         TAG       IMAGE ID        CREATED         SIZE
    starter_php-fpm    latest    fed4dbf5d3f2    28 hours ago    83.5MB
    ```
    - ビルドに成功してたらちゃんと一覧に表示されているはず...
    - nginx はコンテナ起動時に pull されるので大丈夫
4. 以下のコマンドでコンテナ郡を起動してみよう
    ```shell
    $ docker-compose up -d
    ```
    - 多分起動できていることでしょう、以下のコマンドで確認しよう
        ```shell
        $ docker-compose ps

           Name                      Command              State         Ports
        --------------------------------------------------------------------------------
        starter_nginx_1     nginx -g daemon off;            Up      0.0.0.0:80->80/tcp
        starter_php-fpm_1   docker-php-entrypoint php-fpm   Up      9000/tcp
        ```
    - **Tips:** 起動してるコンテナは以下のコマンドで停止、削除できるよ
        ```shell
        $ docker-compose down
        ```

### アプリにアクセスしよう

1. コンテナを起動させた状態で以下のコマンドで初期処理を実行しよう
    ```shell
    $ make init
    ```
2. ブラウザから以下の URL にアクセスしよう！
  - http://localhost
