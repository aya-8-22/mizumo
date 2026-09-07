# frozen_string_literal: true

# lib/tasks/notification.rake
# 通知メールを送信するRakeタスク

# notification という名前空間を定義
namespace :notification do
  # タスクの説明
  desc '通知メールを送信する'
  # タスクの定義（:environment は Rails の環境を読み込むために必要）
  task send_scheduled: :environment do
    # 現在時刻を取得（日本時間）
    current_time = Time.current

    # 【修正】現在の時刻が5分刻みかどうかをチェック
    # 5分刻みでない場合は処理をスキップ
    # 例:8時12分の場合は処理をスキップ
    # 例:8時10分の場合は処理を実行
    unless current_time.min % 5 == 0
      # ログに記録
      Rails.logger.info "現在時刻が5分刻みではないため、処理をスキップしました: #{current_time}"
      # 処理を終了
      next
    end
    
    # 通知タイプの一覧を定義
    # type: 通知の種類、time_field: 時刻のカラム名、enabled_field: 有効/無効のカラム名
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

    # 通知タイプごとに処理を実行
    notification_types.each do |notification|
      # 通知が有効なユーザーを取得
      users = User.where(notification[:enabled_field] => true)

      # ユーザーごとに処理を実行（メモリ効率のため find_each を使用）
      users.find_each do |user|
        # ユーザーの通知時刻を取得
        notification_time = user.send(notification[:time_field])
        # 通知時刻が設定されていない場合はスキップ
        next if notification_time.blank?

        # 【修正】通知時刻の「時」と「分」を取得
        notification_hour = notification_time.hour
        notification_min = notification_time.min
        
        # 【修正】現在時刻の「時」と「分」を取得
        current_hour = current_time.hour
        current_min = current_time.min
        
        # 【修正】通知時刻と現在時刻が完全に一致する場合のみメール送信
        # 例:通知時刻が8時10分で、現在時刻が8時10分の場合のみ送信
        # 例:通知時刻が8時12分で、現在時刻が8時10分の場合は送信しない
        if notification_hour == current_hour && notification_min == current_min
          # メール送信ジョブをキューに追加
          NotificationJob.perform_later(user.id, notification[:type])
          # ログに記録
          Rails.logger.info "通知メール送信: #{user.email} (#{notification[:type]}) at #{current_time}"
        end
      end
    end
  end
end