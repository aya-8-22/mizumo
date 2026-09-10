# frozen_string_literal: true

# app/jobs/notification_job.rb
# 通知メールを送信するバックグラウンドジョブ（Sidekiqジョブ） 
class NotificationJob < ApplicationJob
  # Sidekiq のキューを指定（default キューを使用）
  queue_as :default

  # Resend側のエラー（不正なメールアドレスなど）が発生した場合、リトライせずに諦める設定
  discard_on Resend::Error::InvalidRequestError

  # ジョブが実行されたときに呼び出されるメインの処理
  # user_id: 送信対象のユーザーID
  # notification_type: 通知タイプ（wake_up, breakfast など）
  def perform(user_id, notification_type)
    # user_id からユーザーを検索する（存在しない場合は nil になる）
    user = User.find_by(id: user_id)
    # ユーザーが見つからない場合は処理を中断する
    return unless user

    # メールアドレスが存在し、かつ正しいメールアドレスの形式であるかをチェックする
    unless user.email.present? && user.email.match?(URI::MailTo::EMAIL_REGEXP)
      # 不正な形式だった場合、後で調査できるようにログへ警告を出力する
      Rails.logger.warn("Invalid email for user_id=#{user.id}: #{user.email.inspect}")
      # メール送信を行わずにジョブを正常終了させる
      return
    end

    # 【注意】【修正】無料枠の制限対策：環境変数で指定した自分以外の宛先への送信をここでブロックする（将来課金したらこの行を削除します）
    return unless user.email == ENV['ALLOWED_NOTIFICATION_EMAIL']
    
    # 条件をすべてクリアしたら、実際に通知メールを即時配信する
    NotificationMailer.send_notification(user, notification_type).deliver_now
  end
end