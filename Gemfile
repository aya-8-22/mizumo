# frozen_string_literal: true

# Gemfile
# gem のダウンロード元を指定（通常は公式の RubyGems を使う）
source 'https://rubygems.org'
# GitHub から gem をダウンロードする際の URL 形式を定義
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# このプロジェクトで使用する Ruby のバージョンを指定
ruby '3.1.4'

# ===== フレームワーク =====
# Rails 本体（Web アプリケーションフレームワーク）
# ~> 7.0.10 → 7.0.10 以上 7.1 未満のバージョンを使う
gem 'rails', '~> 7.0.10'

# ===== アセット関連（CSS、JavaScript、画像などの管理）=====
# Rails の従来のアセットパイプライン（CSS、JavaScript、画像を管理するツール）
gem 'sprockets-rails'

# JavaScript を ESM インポートマップで管理するツール（モダンな JavaScript 管理方法）
gem 'importmap-rails'

# Hotwire のページ高速化ツール（ページ遷移を高速化）
gem 'turbo-rails'

# Hotwire の軽量 JavaScript フレームワーク（画面の一部だけを更新できる）
gem 'stimulus-rails'

# ===== データベース関連 =====
# PostgreSQL データベースを使うための gem
gem 'pg', '~> 1.1'

# ===== Web サーバー =====
# Puma Web サーバー（Rails アプリケーションを動かすサーバー）
gem 'puma', '>= 5.0'

# ===== JSON API 構築 =====
# JSON 形式の API を簡単に作成できるツール
gem 'jbuilder'

# ===== タイムゾーンデータ =====
# Windows ではタイムゾーンデータが含まれていないため、この gem が必要
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# ===== 起動高速化 =====
# Rails アプリケーションの起動を高速化するツール（キャッシュを使う）
gem 'bootsnap', require: false

# ===== 認証機能（Devise）=====
# ユーザー認証機能を提供する gem（ログイン、ログアウト、パスワードリセットなど）
gem 'devise'

# ===== 国際化（i18n）=====
# Rails の標準的な日本語翻訳を提供する gem
# - ActiveRecord のエラーメッセージが自動的に日本語化される
# - 日付や時刻の表示が自動的に日本語化される
gem 'rails-i18n'

# Devise の画面やメッセージを日本語化する gem
# - ログイン画面、ユーザー登録画面などが自動的に日本語化される
# - エラーメッセージが自動的に日本語化される
gem 'devise-i18n'

# ===== Tailwind CSS =====
# Tailwind CSS を使うための gem
# ユーティリティファーストの CSS フレームワーク
# - クラス名を組み合わせてスタイルを適用できる
# - カスタマイズ性が高く、デザインの自由度が高い
# 【修正】Sass との互換性のため v2 を使用
gem 'tailwindcss-rails', '~> 2.0'

# ===== 開発環境とテスト環境の両方で使用する gem =====
group :development, :test do
  # デバッグツール（binding.pry でコードを一時停止してデバッグできる）
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  # RuboCop 本体（Ruby のコードスタイルをチェックするツール）
  # - コードの書き方が統一されているかをチェック
  # - 自動修正機能もある
  # require: false → コマンドラインで使うため、起動時に読み込まない
  gem 'rubocop', require: false

  # RuboCop の Rails 用拡張（Rails プロジェクトに最適化された設定）
  # - Rails 特有のコードスタイルをチェック
  # - Rails のベストプラクティスに従っているかを確認
  gem 'rubocop-rails', require: false

  # RuboCop の RSpec 用拡張（RSpec のテストコードに最適化された設定）
  # - RSpec のテストコードのスタイルをチェック
  # - テストコードの書き方が統一されているかを確認
  gem 'rubocop-rspec', require: false

  # エラー画面をわかりやすく表示してくれるツール
  # エラーが発生した時に、詳細な情報を見やすく表示してくれる
  gem 'better_errors'

  # better_errors と一緒に使うことで、エラー画面で変数の中身を確認できる
  # エラー画面でコンソールを開いて、その場で変数の値を確認したり、コードを実行できる
  gem 'binding_of_caller'
end

# ===== 開発環境でのみ使用する gem =====
group :development do
  # ブラウザでエラーページにコンソールを表示するツール
  # エラーが発生した時に、ブラウザ上でコンソールを開いてデバッグできる
  gem 'web-console'

  # N+1 問題を検出してくれるツール（データベースへの無駄なアクセスを警告してくれる）
  # N+1 問題 → データベースへのアクセスが無駄に多くなってしまう問題
  # 例：ユーザー一覧を表示する時に、各ユーザーの投稿数を表示しようとすると、
  #     ユーザー数分だけデータベースにアクセスしてしまう（無駄が多い）
  # Bullet はこのような問題を検出して警告してくれる
  gem 'bullet'
end

# ===== テスト環境でのみ使用する gem =====
group :test do
  # システムテストを実行するためのツール（ブラウザを自動操作してテストできる）
  # 例：ユーザーがログインボタンをクリックして、正しくログインできるかをテストする
  gem 'capybara'

  # システムテストで Chrome ブラウザを使うためのドライバー
  # Capybara と組み合わせて、実際のブラウザでテストを実行できる
  gem 'selenium-webdriver'
end
