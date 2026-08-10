# frozen_string_literal: true

# config/initializers/sidekiq.rb
# 【追加】Sidekiq の初期設定ファイル（Redis への接続設定を管理）

# Sidekiq のサーバー側の設定（ジョブを処理する側）
Sidekiq.configure_server do |config|
  # Redis への接続設定
  # ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')で環境変数REDIS_URLを取得
  # 環境変数が設定されていない場合はデフォルト値redis://localhost:6379/0を使用
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end

# Sidekiq のクライアント側の設定（ジョブを登録する側）
Sidekiq.configure_client do |config|
  # Redisへの接続設定を行う
  # ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')で環境変数REDIS_URLを取得
  # 環境変数が設定されていない場合はデフォルト値redis://localhost:6379/0を使用
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end