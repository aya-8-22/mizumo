# frozen_string_literal: true

# config/application.rb
# アプリケーション全体の設定を管理するファイル
# デフォルトロケール（言語設定）をここで指定します

# Railsの起動に必要なファイルを読み込む
require_relative 'boot'

# Rails のすべての機能を読み込む
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
# Gemfile に記載された gem を読み込む
# 環境（development, test, production）ごとに必要な gem だけを読み込む
Bundler.require(*Rails.groups)

# アプリケーションのモジュール定義
module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # Rails 7.0 のデフォルト設定を読み込む
    config.load_defaults 7.0

    # タイムゾーンを日本時間に設定
    config.time_zone = 'Tokyo'
    
    # データベースのタイムゾーンを 世界標準のUTC に設定
    config.active_record.default_timezone = :utc

    # エラーメッセージや日付フォーマットなどが日本語で表示
    config.i18n.default_locale = :ja

    # 利用可能なロケールを設定
    config.i18n.available_locales = %i[ja en]

    # 翻訳ファイルのパスを指定（config/locales 配下のすべての yml ファイルを読み込む）
    config.i18n.load_path += Rails.root.glob('config/locales/**/*.{rb,yml}')

    # バックグラウンドジョブの処理に Sidekiq を使用する設定
    # Active Job で Sidekiq を使うように設定
    config.active_job.queue_adapter = :sidekiq

    # 【追加】Sass プロセッサーを無効化（sassc エラーを解決）
    # Sprockets が Sass ファイルを処理しようとするのを防ぐ
    config.assets.configure do |env|
      # Sprockets::SassCompressor が定義されている場合のみ登録解除
      if defined?(Sprockets::SassCompressor)
        env.unregister_preprocessor('text/css', Sprockets::SassCompressor)
      end
      # Sprockets::ScssTemplate が定義されている場合のみ登録解除
      if defined?(Sprockets::ScssTemplate)
        env.unregister_preprocessor('text/css', Sprockets::ScssTemplate)
      end
      # Sprockets::SasscProcessor が定義されている場合のみ登録解除
      if defined?(Sprockets::SasscProcessor)
        env.unregister_preprocessor('text/css', Sprockets::SasscProcessor)
      end
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
