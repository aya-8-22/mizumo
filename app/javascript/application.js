// app/javascript/application.js
// Webサイトに動きやインタラクティブな機能を追加するための、JavaScriptプログラムの司令塔(玄関口)

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// Turbo Rails を読み込む(ページ遷移を高速化)
import "@hotwired/turbo-rails"

// Stimulus コントローラーを読み込む
import "controllers"

// 【修正】パスワード表示/非表示機能を読み込む
import "password_toggle"

// 【修正】通知トグル機能を読み込む
import "notification_toggle"

// 【修正】飲水記録機能を読み込む
import "water_intakes"