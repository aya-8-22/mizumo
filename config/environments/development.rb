# config/environments/development.rb
# frozen_string_literal: true

# Railsの時間関連のメソッドを使えるようにする
require 'active_support/core_ext/integer/time'

# 開発環境の設定を開始
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # ===== 基本設定 =====
  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  # コードの変更を自動的に反映する(クラスをキャッシュしない)
  config.cache_classes = false

  # Do not eager load code on boot.
  # 起動時にすべてのコードを読み込まない(高速起動)
  config.eager_load = false

  # Show full error reports.
  # エラー画面に詳細な情報を表示する
  config.consider_all_requests_local = true

  # Enable server timing
  # サーバーのパフォーマンス情報を記録する
  config.server_timing = true

  # ===== キャッシュ設定 =====
  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  # tmp/caching-dev.txt ファイルが存在する場合
  if Rails.root.join('tmp/caching-dev.txt').exist?
    # キャッシュを有効化
    config.action_controller.perform_caching = true
    # フラグメントキャッシュのログを記録
    config.action_controller.enable_fragment_cache_logging = true

    # メモリにキャッシュを保存
    config.cache_store = :memory_store
    # 静的ファイルのキャッシュ期間を2日に設定
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    # キャッシュを無効化
    config.action_controller.perform_caching = false

    # キャッシュを保存しない
    config.cache_store = :null_store
  end

  # ===== ファイルストレージ設定 =====
  # Store uploaded files on the local file system (see config/storage.yml for options).
  # アップロードされたファイルをローカルに保存
  config.active_storage.service = :local

  # ===== メール設定 =====
  # Don't care if the mailer can't send.
  # メール送信エラーを表示しない
  config.action_mailer.raise_delivery_errors = false

  # メールのキャッシュを無効化
  config.action_mailer.perform_caching = false

  # 【追加】Devise のメール送信設定　Docker環境のためホスト名を文字列で指定
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # letter_opener_web を使う場合（パスワードリセット機能で使います）
  # config.action_mailer.delivery_method = :letter_opener_web

  # ===== ログ設定 =====
  # Print deprecation notices to the Rails logger.
  # 非推奨の機能を使った場合、ログに記録
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  # 禁止された非推奨機能を使った場合、エラーを発生
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  # 禁止する非推奨機能の警告リスト(空)
  config.active_support.disallowed_deprecation_warnings = []

  # ===== データベース設定 =====
  # Raise an error on page load if there are pending migrations.
  # マイグレーションが実行されていない場合、エラーページを表示
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  # SQLクエリの実行場所をログに記録
  config.active_record.verbose_query_logs = true

  # ===== アセット設定 =====
  # Suppress logger output for asset requests.
  # アセットのログを非表示にする
  config.assets.quiet = true

  # ===== その他の設定 =====
  # Raises error for missing translations.
  # 翻訳が見つからない場合、エラーを発生させる(コメントアウト)
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # ビューファイルにファイル名を注釈として追加(コメントアウト)
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # Action Cableのリクエスト偽造保護を無効化(コメントアウト)
  # config.action_cable.disable_request_forgery_protection = true

  # ===== 【追加】Bullet N+1問題を検出してくれるgem の設定 =====
  config.after_initialize do
    Bullet.enable = true                # Bulletを有効化
    Bullet.alert = true                 # ブラウザにアラートを表示
    Bullet.bullet_logger = true         # Bulletのログファイルに記録
    Bullet.console = true               # コンソールに出力
    Bullet.rails_logger = true          # Railsのログに記録
    Bullet.add_footer = true            # ページの下部に警告を表示
  end
end
