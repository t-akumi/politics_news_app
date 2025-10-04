# Dockerfile (本番用)
FROM ruby:3.2.2

# 必要パッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev 

# 作業ディレクトリを作成
WORKDIR /my_app

# Build-time 引数として master key を受け取る
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

ARG OPENAI_API_KEY
ENV OPENAI_API_KEY=${OPENAI_API_KEY}

# Gemfile をコピーして bundle install
COPY Gemfile Gemfile.lock package.json yarn.lock ./
#RUN yarn install
RUN gem install bundler -v 2.4.13
RUN bundle install --without development test

# JSの圧縮ツール
# RUN yarn add --dev terser

# アプリケーションコードをコピー
COPY . .

# プリコンパイル（本番環境用）
RUN RAILS_ENV=production bin/rails assets:precompile

# デフォルトコマンド（Render はここを使って本番起動）
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-e", "production"]
