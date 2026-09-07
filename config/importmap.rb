# frozen_string_literal: true

# 【修正】文字列を変更不可にして、メモリ使用量を削減する設定
# config/importmap.rb
# 【修正】Importmap の設定ファイル(JavaScriptファイルの読み込み設定)

# Pin npm packages by running ./bin/importmap
# npm パッケージを読み込むための設定を記述するコメント

# application.js を読み込む設定
pin 'application'
# Turbo Rails 本体を読み込む設定
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
# Stimulus コントローラーを読み込む設定
pin '@hotwired/stimulus', to: 'stimulus.min.js'
# Stimulus の読み込み設定
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
# controllers ディレクトリ配下のファイルを読み込む設定
pin_all_from 'app/javascript/controllers', under: 'controllers'

# 【修正】パスワード表示/非表示機能を読み込む設定
pin 'password_toggle', to: 'password_toggle.js'
# 【修正】通知トグル機能を読み込む設定
pin 'notification_toggle', to: 'notification_toggle.js'
# 【修正】飲水記録機能を読み込む設定
pin 'water_intakes', to: 'water_intakes.js'