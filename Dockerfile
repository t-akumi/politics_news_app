# ベースイメージを指定（Ruby 3.1, Debianベースで安定）
FROM ruby:3.1

# 必要パッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs yarn

# 作業ディレクトリを作成
WORKDIR /my_app

# Gemfileをコピーし、bundle install
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.13  # バージョン固定
RUN bundle install

# アプリケーションコードをコピー
COPY . .

# デフォルトコマンド
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
