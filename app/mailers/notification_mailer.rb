# frozen_string_literal: true

# app/mailers/notification_mailer.rb
# 通知メールを送信するメーラー
class NotificationMailer < ApplicationMailer
  # 【修正】毎日のリマインダーメールを送信するメソッド
  def daily_reminder(user)
    # インスタンス変数にユーザー情報を格納
    @user = user
    # メールを送信
    mail(to: @user.email, subject: '今日の通知')
  end
end
