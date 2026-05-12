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

    # 【追加】エラーメッセージや日付フォーマットなどが日本語で表示
    config.i18n.default_locale = :ja

    # 【追加】利用可能なロケールを設定
    config.i18n.available_locales = %i[ja en]
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
