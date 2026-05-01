# Ruby 3.1.4 の公式イメージを使用
FROM ruby:3.1.4

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# Gemfile と Gemfile.lock をコピー
COPY Gemfile Gemfile.lock ./

# bundle install を実行
RUN bundle install

# アプリケーションのコードをコピー
COPY . .

# Rails サーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]