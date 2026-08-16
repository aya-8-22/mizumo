# frozen_string_literal: true

# 【追加】app/jobs/notification_job.rb
# 通知メールを送信するバックグラウンドジョブ（Sidekiqジョブ） 
class NotificationJob < ApplicationJob
  # Sidekiq のキューを指定（default キューを使用）
  queue_as :default

  # ジョブの実行内容を定義
  # user_id: 送信対象のユーザーID
  # notification_type: 通知タイプ（wake_up, breakfast など）
  def perform(user_id, notification_type)
    # User が見つからない場合は処理をスキップ
    user = User.find_by(id: user_id)
    return unless user
    
    # メールを送信
    NotificationMailer.send_notification(user, notification_type).deliver_now
  end
end