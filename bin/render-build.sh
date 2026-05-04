#【追加】!/usr/bin/env bash このスクリプトをbashで実行することを宣言
#エラーが発生したら即座に終了
set -o errexit

# Gemをインストール
bundle install

# アセット（CSS、JavaScript）をプリコンパイル
bundle exec rails assets:precompile

#古いアセットを削除
bundle exec rails assets:clean

# 以下を追加（無料プランの場合）
bundle exec rails db:migrate