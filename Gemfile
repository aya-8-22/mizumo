# frozen_string_literal: true

# Gemfile
# gemのダウンロード元を指定（通常は公式のRubyGemsを使う）
source 'https://rubygems.org'
# GitHubからgemをダウンロードする際のURL形式を定義
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# このプロジェクトで使用するRubyのバージョンを指定
ruby '3.1.4'

# ===== フレームワーク =====
# Rails本体（Webアプリケーションフレームワーク）
# ~> 7.0.10 → 7.0.10以上7.1未満のバージョンを使う
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.10'

# ===== アセット関連（CSS、JavaScript、画像などの管理）=====
# Railsの従来のアセットパイプライン（CSS、JavaScript、画像を管理するツール）
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# JavaScriptをESMインポートマップで管理するツール（モダンなJavaScript管理方法）
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwireのページ高速化ツール（ページ遷移を高速化）
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwireの軽量JavaScriptフレームワーク（画面の一部だけを更新できる）
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# ===== データベース関連 =====
# PostgreSQLデータベースを使うためのgem
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# ===== Webサーバー =====
# Puma Webサーバー（Railsアプリケーションを動かすサーバー）
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# ===== JSON API構築 =====
# JSON形式のAPIを簡単に作成できるツール
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# ===== Redis（キャッシュやバックグラウンドジョブに使う）=====
# Redisを使う場合はコメントを外す（現在は使わない設定）
# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# ===== Kredis（Redisを使った高レベルなデータ型）=====
# Kredisを使う場合はコメントを外す（現在は使わない設定）
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# ===== パスワード暗号化 =====
# パスワードを暗号化するためのgem（has_secure_passwordを使う場合に必要）
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# ===== タイムゾーンデータ =====
# Windowsではタイムゾーンデータが含まれていないため、このgemが必要
# mingw、mswin、x64_mingw、jrubyプラットフォームでのみインストールされる
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# ===== 起動高速化 =====
# Railsアプリケーションの起動を高速化するツール（キャッシュを使う）
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# =====【追加】Sass（CSSプリプロセッサ）=====
# SassでCSSを書く場合はコメントを外す（現在は使わない設定）
# Use Sass to process CSS
gem 'sassc-rails'

# ===== 画像処理 =====
# Active Storageで画像を加工する場合はコメントを外す（現在は使わない設定）
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# ===== 【追加】認証機能（Devise）=====
# ユーザー認証機能を提供するgem（ログイン、ログアウト、パスワードリセットなど）
# 開発環境、テスト環境、本番環境のすべてで使用するため、グループの外に記述
gem 'devise'

# ===== 【追加】国際化（i18n）=====
# Rails の標準的な日本語翻訳を提供するgem
# - ActiveRecord のエラーメッセージが自動的に日本語化される
# - Devise のエラーメッセージが自動的に日本語化される
# - 日付や時刻の表示が自動的に日本語化される
gem 'rails-i18n'

# ===== 【追加】Devise の日本語翻訳 =====
# Devise の画面やメッセージを日本語化するgem
# - ログイン画面、ユーザー登録画面などが自動的に日本語化される
# - エラーメッセージが自動的に日本語化される
# - フラッシュメッセージ（「ログインしました」など）が自動的に日本語化される
# rails-i18n と組み合わせることで、Devise 関連の表示がすべて日本語になる
gem 'devise-i18n'

# ===== 開発環境とテスト環境の両方で使用するgem =====
group :development, :test do
  # デバッグツール（binding.pryでコードを一時停止してデバッグできる）
  # platforms: %i[ mri mingw x64_mingw ] → 特定のRuby実装でのみインストール
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  # 【追加】Rubyのコードスタイルをチェックするツール（Rails用）
  # Railsプロジェクトに最適化されたRuboCopの設定が含まれている
  # require: false → Railsアプリケーション起動時に自動読み込みしない（コマンドラインで使うため）
  gem 'rubocop-rails', require: false
  # 【追加】Rubyのコードスタイルをチェックするツール（RSpec用）
  # RSpecのテストコードに最適化されたRuboCopの設定が含まれている
  # require: false → Railsアプリケーション起動時に自動読み込みしない（コマンドラインで使うため）
  gem 'rubocop-rspec', require: false
  # 【追加】エラー画面をわかりやすく表示してくれるツール
  # エラーが発生した時に、詳細な情報を見やすく表示してくれる
  gem 'better_errors'
  # 【追加】better_errorsと一緒に使うことで、エラー画面で変数の中身を確認できる
  # エラー画面でコンソールを開いて、その場で変数の値を確認したり、コードを実行できる
  gem 'binding_of_caller'
end

# ===== 開発環境でのみ使用するgem =====
group :development do
  # ブラウザでエラーページにコンソールを表示するツール
  # エラーが発生した時に、ブラウザ上でコンソールを開いてデバッグできる
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
  # 【追加】N+1問題を検出してくれるツール（データベースへの無駄なアクセスを警告してくれる）
  # N+1問題 → データベースへのアクセスが無駄に多くなってしまう問題
  # 例：ユーザー一覧を表示する時に、各ユーザーの投稿数を表示しようとすると、
  #     ユーザー数分だけデータベースにアクセスしてしまう（無駄が多い）
  # Bulletはこのような問題を検出して警告してくれる
  gem 'bullet'

  # パフォーマンス測定ツール（ページの表示速度を測定できる）
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # コマンド実行を高速化するツール（大規模なアプリケーションで有効）
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

# ===== テスト環境でのみ使用するgem =====
group :test do
  # システムテストを実行するためのツール（ブラウザを自動操作してテストできる）
  # 例：ユーザーがログインボタンをクリックして、正しくログインできるかをテストする
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  # システムテストでChromeブラウザを使うためのドライバー
  # Capybaraと組み合わせて、実際のブラウザでテストを実行できる
  gem 'selenium-webdriver'
end

# =====【追加】Tailwind CSS =====
# Tailwind CSS を使うための gem
# ユーティリティファーストの CSS フレームワーク
# - クラス名を組み合わせてスタイルを適用できる
# - カスタマイズ性が高く、デザインの自由度が高い
gem "tailwindcss-rails", "~> 3.3.1"

