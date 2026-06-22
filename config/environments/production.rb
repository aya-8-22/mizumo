# frozen_string_literal: true

# config/environments/production.rb
# 本番環境の設定ファイル

# Railsの便利な機能を読み込む
require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # ===== 基本設定 =====
  # このファイルの設定が config/application.rb より優先される
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  # リクエストごとにコードを再読み込みしない（高速化）
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  # 起動時に全コードを読み込む（メモリ使用量↑、速度↑）
  config.eager_load = true

  # ===== エラー表示とキャッシュ =====
  # Full error reports are disabled and caching is turned on.
  # 詳細なエラー画面を表示しない（セキュリティ）
  config.consider_all_requests_local       = false
  # キャッシュを有効化（パフォーマンス向上）
  config.action_controller.perform_caching = true

  # ===== セキュリティ設定 =====
  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true
  # master.key が必要（暗号化データの復号化用）
  # config.require_master_key = true

  # ===== 静的ファイル配信設定 =====
  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  # 環境変数が設定されている場合のみ静的ファイルを配信
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # ===== アセット設定 =====
  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass
  # CSS 圧縮設定（コメントアウト中）
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  # プリコンパイル済みアセットのみ使用
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"
  # CDN 使用時の設定（コメントアウト中）
  # config.asset_host = "http://assets.example.com"

  # ===== ファイル送信設定 =====
  # Specifies the header that your server uses for sending files.
  # Web サーバー経由のファイル送信設定（コメントアウト中）
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # ===== ファイルストレージ設定 =====
  # Store uploaded files on the local file system (see config/storage.yml for options).
  # アップロードファイルをローカルに保存
  config.active_storage.service = :local

  # ===== Action Cable 設定 =====
  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # ===== SSL 設定 =====
  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # 全アクセスを HTTPS に強制（コメントアウト中）
  # config.force_ssl = true

  # ===== ログ設定 =====
  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  # ログレベルを info に設定（個人情報漏洩防止）
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # 各ログ行に request_id を追加（追跡用）
  config.log_tags = [:request_id]

  # ===== キャッシュストア設定 =====
  # Use a different cache store in production.
  # Memcached や Redis 使用時の設定（コメントアウト中）
  # config.cache_store = :mem_cache_store

  # ===== バックグラウンドジョブ設定 =====
  # Use a real queuing backend for Active Job (and separate queues per environment).
  # 非同期ジョブの設定（コメントアウト中）
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "app_production"

  # ===== メール設定 =====
  # メール送信時のキャッシュを無効化
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # メール送信エラーを無視（コメントアウト中）
  # config.action_mailer.raise_delivery_errors = false

  # ===== 国際化設定 =====
  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  # 翻訳がない場合、デフォルト言語にフォールバック
  config.i18n.fallbacks = true

  # ===== 非推奨機能の警告設定 =====
  # Don't log any deprecations.
  # 非推奨機能の警告を出力しない
  config.active_support.report_deprecations = false

  # ===== ログフォーマット設定 =====
  # Use default logging formatter so that PID and timestamp are not suppressed.
  # 標準フォーマットでログを出力
  config.log_formatter = Logger::Formatter.new

  # ===== 分散環境用ログ設定 =====
  # Use a different logger for distributed setups.
  # Syslog 使用時の設定（コメントアウト中）
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new "app-name")

  # Renderのホストを許可
  config.hosts << 'mizumo.onrender.com'
  # 【追加】Renderのドメインを許可
  config.hosts << "mizumo-db-neon.onrender.com"


  # 開発段階では全て許可（本番では削除推奨）
  # config.hosts.clear

  # ===== 標準出力へのログ設定 =====
  # 環境変数が設定されている場合、標準出力にログを出力
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # ===== データベース設定 =====
  # Do not dump schema after migrations.
  # マイグレーション後に schema.rb を更新しない
  config.active_record.dump_schema_after_migration = false
end
