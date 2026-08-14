# frozen_string_literal: true

# 【追加】lib/tasks/notification.rake
# 通知メールを送信するRakeタスク

# notification という名前空間を定義
namespace :notification do
  # send_reminders というタスクを定義
  desc '通知メールを送信する'
  task send_reminders: :environment do
    # 現在時刻を取得（日本時間）
    current_time = Time.current

    # 8つの通知タイプを配列で定義
    notification_types = [
      { type: 'wake_up', time_field: :wake_up_time, enabled_field: :wake_up_enabled },
      { type: 'breakfast', time_field: :breakfast_time, enabled_field: :breakfast_enabled },
      { type: 'morning', time_field: :morning_time, enabled_field: :morning_enabled },
      { type: 'lunch', time_field: :lunch_time, enabled_field: :lunch_enabled },
      { type: 'afternoon', time_field: :afternoon_time, enabled_field: :afternoon_enabled },
      { type: 'bath', time_field: :bath_time, enabled_field: :bath_enabled },
      { type: 'dinner', time_field: :dinner_time, enabled_field: :dinner_enabled },
      { type: 'bedtime', time_field: :bedtime, enabled_field: :bedtime_enabled }
    ]

    # 各通知タイプごとに処理
    notification_types.each do |notification|
      # 通知が有効なユーザーを取得
      users = User.where(notification[:enabled_field] => true)

      # 各ユーザーに対して処理
      users.find_each do |user|
        # ユーザーの通知時間を取得
        notification_time = user.send(notification[:time_field])

        # 通知時間が設定されていない場合はスキップ
        next if notification_time.blank?

        # 通知時間を Time オブジェクトに変換（今日の日付で）
        notification_datetime = Time.zone.parse("#{current_time.to_date} #{notification_time.strftime('%H:%M')}")

        # 現在時刻と通知時間の差分を計算（分単位）
        time_diff = ((current_time - notification_datetime) / 60).abs

        # 差分が5分以内の場合にメールを送信
        if time_diff <= 5
          # バックグラウンドジョブでメールを送信
          NotificationJob.perform_later(user.id, notification[:type])
          
          # ログに記録
          Rails.logger.info "通知メール送信: #{user.email} (#{notification[:type]})"
        end
      end
    end
  end
end