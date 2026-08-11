# frozen_string_literal: true

# config/initializers/sidekiq.rb
# Sidekiq の初期設定ファイル（Redis への接続設定を管理）

# Sidekiq のサーバー側の設定（ジョブを処理する側）
Sidekiq.configure_server do |config|
  # 【修正】Redis への接続設定（Docker Compose の場合は redis という名前で接続）
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0') }
end

# Sidekiq のクライアント側の設定（ジョブを登録する側）
Sidekiq.configure_client do |config|
  # 【修正】Redis への接続設定（Docker Compose の場合は redis という名前で接続）
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0') }
end