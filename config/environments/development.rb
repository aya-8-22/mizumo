# frozen_string_literal: true

# 文字列リテラルを凍結（メモリ節約・パフォーマンス向上）

# config/environments/development.rb

# Railsの時間関連のメソッドを使えるようにする
require 'active_support/core_ext/integer/time'

# 開発環境の設定を開始
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  # 【修正】この設定が config/application.rb より優先される

  # ===== 基本設定 =====
  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  # 【修正】コードの変更を自動的に反映する(クラスをキャッシュしない)
  config.cache_classes = false

  # Do not eager load code on boot.
  # 【修正】起動時にすべてのコードを読み込まない(高速起動)
  config.eager_load = false

  # ===== エラー表示とキャッシュ =====
  # Show full error reports.
  # 【修正】エラー画面に詳細な情報を表示する
  config.consider_all_requests_local = true

  # Enable server timing
  # 【修正】サーバーのパフォーマンス情報を記録する
  config.server_timing = true

  # ===== キャッシュ設定 =====
  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  # 【修正】tmp/caching-dev.txt ファイルが存在する場合
  if Rails.root.join('tmp/caching-dev.txt').exist?
    # 【修正】キャッシュを有効化
    config.action_controller.perform_caching = true
    # 【修正】フラグメントキャッシュのログを記録
    config.action_controller.enable_fragment_cache_logging = true

    # 【修正】メモリにキャッシュを保存
    config.cache_store = :memory_store
    # 【修正】静的ファイルのキャッシュ期間を2日に設定
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    # 【修正】キャッシュを無効化
    config.action_controller.perform_caching = false

    # 【修正】キャッシュを保存しない
    config.cache_store = :null_store
  end

  # ===== ファイルストレージ設定 =====
  # Store uploaded files on the local file system (see config/storage.yml for options).
  # 【修正】アップロードされたファイルをローカルに保存
  config.active_storage.service = :local

  # ===== メール設定 =====
  # Don't care if the mailer can't send.
  # 【修正】メール送信エラーを表示しない
  config.action_mailer.raise_delivery_errors = false

  # 【修正】メールのキャッシュを無効化
  config.action_mailer.perform_caching = false

  # 【修正】メール送信時のURL設定(Docker環境のためホスト名を文字列で指定)
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # 【修正】letter_opener_web を使う場合（パスワードリセット機能で使います）
  config.action_mailer.delivery_method = :letter_opener_web

  # ===== ログ設定 =====
  # Print deprecation notices to the Rails logger.
  # 【修正】非推奨の機能を使った場合、ログに記録
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  # 【修正】禁止された非推奨機能を使った場合、エラーを発生
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  # 【修正】禁止する非推奨機能の警告リスト(空)
  config.active_support.disallowed_deprecation_warnings = []

  # ===== データベース設定 =====
  # Raise an error on page load if there are pending migrations.
  # 【修正】マイグレーションが実行されていない場合、エラーページを表示
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  # 【修正】SQLクエリの実行場所をログに記録
  config.active_record.verbose_query_logs = true

  # ===== アセット設定 =====
  # Suppress logger output for asset requests.
  # 【修正】アセットのログを非表示にする
  config.assets.quiet = true

  # ===== その他の設定 =====
  # Raises error for missing translations.
  # 【修正】翻訳が見つからない場合、エラーを発生させる(コメントアウト)
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # 【修正】ビューファイルにファイル名を注釈として追加(コメントアウト)
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # 【修正】Action Cableのリクエスト偽造保護を無効化(コメントアウト)
  # config.action_cable.disable_request_forgery_protection = true

  # ===== 【追加】Bullet N+1問題を検出してくれるgem の設定 =====
  config.after_initialize do
    # 【修正】Bulletを有効化
    Bullet.enable = true
    # 【修正】ブラウザにアラートを表示
    Bullet.alert = true
    # 【修正】Bulletのログファイルに記録
    Bullet.bullet_logger = true
    # 【修正】コンソールに出力
    Bullet.console = true
    # 【修正】Railsのログに記録
    Bullet.rails_logger = true
    # 【修正】ページの下部に警告を表示
    Bullet.add_footer = true
  end
end
