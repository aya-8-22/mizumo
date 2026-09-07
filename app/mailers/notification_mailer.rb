# frozen_string_literal: true

# app/mailers/notification_mailer.rb
# 通知メールを送信するメーラー
class NotificationMailer < ApplicationMailer
  #【修正】 通知メールを送信するメソッド
  # user: 送信対象のユーザー
  # notification_type: 通知タイプ（wake_up, breakfast など）
  def send_notification(user, notification_type)
    # インスタンス変数にユーザー情報を格納
    @user = user
    
    # インスタンス変数に通知タイプを格納
    @notification_type = notification_type
    
    # 通知タイプに応じた件名を取得
    subject = notification_subject(notification_type)
    
    # メールを送信
    mail(to: @user.email, subject: subject)
  end

  private

  # 【修正】通知タイプに応じた件名を返すメソッド
  def notification_subject(notification_type)
    # 通知タイプに応じた件名を定義
    case notification_type
    when 'wake_up'
      '【起床時】水分摂取のお知らせ'
    when 'breakfast'
      '【朝食時】水分摂取のお知らせ'
    when 'morning'
      '【10時頃】水分摂取のお知らせ'
    when 'lunch'
      '【昼食時】水分摂取のお知らせ'
    when 'afternoon'
      '【15時頃】水分摂取のお知らせ'
    when 'bath'
      '【入浴時】水分摂取のお知らせ'
    when 'dinner'
      '【夕食時】水分摂取のお知らせ'
    when 'bedtime'
      '【就寝時】水分摂取のお知らせ'
    else
      # デフォルトの件名
      '水分摂取のお知らせ'
    end
  end
end