# frozen_string_literal: true

# 【追加】app/services/notification_scheduler.rb
# 通知メール送信のスケジュール処理を担当するクラス
class NotificationScheduler
  # 通知タイプの一覧を定義
  # type: 通知の種類、time_field: 時刻のカラム名、enabled_field: 有効/無効のカラム名
  NOTIFICATION_TYPES = [
    { type: 'wake_up', time_field: :wake_up_time, enabled_field: :wake_up_enabled },
    { type: 'breakfast', time_field: :breakfast_time, enabled_field: :breakfast_enabled },
    { type: 'morning', time_field: :morning_time, enabled_field: :morning_enabled },
    { type: 'lunch', time_field: :lunch_time, enabled_field: :lunch_enabled },
    { type: 'afternoon', time_field: :afternoon_time, enabled_field: :afternoon_enabled },
    { type: 'bath', time_field: :bath_time, enabled_field: :bath_enabled },
    { type: 'dinner', time_field: :dinner_time, enabled_field: :dinner_enabled },
    { type: 'bedtime', time_field: :bedtime, enabled_field: :bedtime_enabled }
  ].freeze

  # クラスメソッドとして呼び出せるようにする( NotificationScheduler.call で実行できる )
  def self.call
    new.call
  end

  # メインの処理
  def call
    # 現在の時刻を変数に格納する
    current_time = Time.current

    # 5分刻みでない場合は処理をスキップ
    unless (current_time.min % 5).zero?
      Rails.logger.info "現在時刻が5分刻みではないため、処理をスキップしました: #{current_time}"
      return
    end

    # 定義されたすべての通知タイプを1つずつ取り出してループ処理する
    NOTIFICATION_TYPES.each do |notification|
      send_notifications_for(notification, current_time)
    end
  end

  private

  # 1つの通知タイプについて、対象ユーザーに通知を送る
  def send_notifications_for(notification, current_time)
    # 該当の通知設定が「有効（true）」になっているユーザーだけをデータベースから絞り込む
    users = User.where(notification[:enabled_field] => true)

    # 該当ユーザーをメモリを圧迫しないよう少しずつ（find_eachで）取り出して処理する
    users.find_each do |user|
      notify_user_if_matched(user, notification, current_time)
    end
  end

  # ユーザーの通知時刻と現在時刻が一致していればメール送信ジョブを実行する
  def notify_user_if_matched(user, notification, current_time)
    # ユーザーが設定している通知時刻を取得する
    notification_time = user.send(notification[:time_field])
    # 通知時刻が設定されていない（空の）場合は処理を中断する
    return if notification_time.blank?

    # 通知時刻と現在時刻が完全に一致する場合のみメール送信
    return unless notification_time.hour == current_time.hour && notification_time.min == current_time.min

    # 条件に完全に一致した場合、裏側（非同期）でメールを送信するジョブをエンキュー（予約）する
    NotificationJob.perform_later(user.id, notification[:type])
    # 処理が成功したことをRailsのログファイルに記録する
    Rails.logger.info "通知メール送信: #{user.email} (#{notification[:type]}) at #{current_time}"
  end
end
