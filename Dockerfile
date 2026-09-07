# Dockerfile
# コンテナのOSからRuby本体、必要なツールまでを定義する、環境構築の設計図

# Ruby 3.2.4 の公式イメージを使用
FROM ruby:3.2.4

# 環境変数を設定
# 文字コードを UTF-8 に設定（日本語を扱う場合に重要）
# タイムゾーンを日本時間に設定
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

# 必要なパッケージをインストール
# apt-get update -qq : パッケージリストを静かに更新
RUN apt-get update -qq \

# build-essential : C 言語で書かれた gem をビルドするために必要なツール群
# libpq-dev : Rails から PostgreSQL に接続するために必要なライブラリ
# nodejs : Rails 7 で最小限必要な JavaScript ランタイム
&& apt-get install -y build-essential libpq-dev nodejs \

# インストール後の不要なファイルを削除してイメージサイズを削減
&& rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
RUN mkdir /app
# 作業ディレクトリを /appに設定（以降のコマンドはこのディレクトリで実行される）
WORKDIR /app

# Bundler のバージョンを指定
# Gemfile.lock に記載されているバージョンと一致させることで依存関係のエラーを防ぐ
RUN gem install bundler:2.3.17

# Gemfile と Gemfile.lock をコピー
# ホストマシンの Gemfile を /app/Gemfile にコピー
COPY Gemfile /app/Gemfile
# ホストマシンの Gemfile.lock を /app/Gemfile.lock にコピー
COPY Gemfile.lock /app/Gemfile.lock

# bundle install を実行
# Gemfile に記載された gem をインストール
RUN bundle install

# アプリケーションのコードをコピー
COPY . /app