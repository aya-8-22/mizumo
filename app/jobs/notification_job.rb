# frozen_string_literal: true

# app/jobs/notification_job.rb
# 通知メールを送信するバックグラウンドジョブ（Sidekiqジョブ） 
class NotificationJob < ApplicationJob
  # Sidekiq のキューを指定（default キューを使用）
  queue_as :default

  # 【修正】Resend側のエラー（不正なメールアドレスなど）が発生した場合、リトライせずに諦める設定
  discard_on Resend::Error::InvalidRequestError

  # ジョブの実行内容を定義
  # user_id: 送信対象のユーザーID
  # notification_type: 通知タイプ（wake_up, breakfast など）
  def perform(user_id, notification_type)
    # user_id からユーザーを検索する（存在しない場合は nil になる）
    user = User.find_by(id: user_id)
    # ユーザーが見つからない場合は処理を中断する
    return unless user

    # 【修正】メールアドレスが空でないかを確認する
    # メールアドレスの形式が正しいかを正規表現でチェックする
    unless user.email.present? && user.email.match?(URI::MailTo::EMAIL_REGEXP)
      # 【修正】不正な形式だった場合、後で調査できるようにログへ警告を出力する
      Rails.logger.warn("Invalid email for user_id=#{user.id}: #{user.email.inspect}")
      # 【修正】メール送信を行わずにジョブを正常終了させる
      return
    end
    
    # メールを送信
    NotificationMailer.send_notification(user, notification_type).deliver_now
  end
end