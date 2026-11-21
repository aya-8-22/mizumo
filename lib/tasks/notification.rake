# frozen_string_literal: true

# lib/tasks/notification.rake
# 通知メールを送信するRakeタスク
# Rakeタスクは「定期実行の入り口（司令塔）」としての役割だけに特化

# notification という名前空間を定義
namespace :notification do
  # タスクの説明
  desc '通知メールを送信する'
  # タスクの定義（:environment は Rails の環境を読み込むために必要）
  task send_scheduled: :environment do
    # 【修正】実際の処理は NotificationScheduler に任せる
    NotificationScheduler.call
  end
end
