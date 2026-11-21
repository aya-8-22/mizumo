# frozen_string_literal: true

# app/mailers/notification_mailer.rb
# 通知メールを送信するメーラー
class NotificationMailer < ApplicationMailer
  # 【修正】通知タイプごとの件名の対応表(定数)
  NOTIFICATION_SUBJECTS = {
    'wake_up' => '【起床時】水分摂取のお知らせ',
    'breakfast' => '【朝食時】水分摂取のお知らせ',
    'morning' => '【10時頃】水分摂取のお知らせ',
    'lunch' => '【昼食時】水分摂取のお知らせ',
    'afternoon' => '【15時頃】水分摂取のお知らせ',
    'bath' => '【入浴時】水分摂取のお知らせ',
    'dinner' => '【夕食時】水分摂取のお知らせ',
    'bedtime' => '【就寝時】水分摂取のお知らせ'
  }.freeze

  # 通知メールを送信するメソッド
  # user: 送信対象のユーザー
  # notification_type: 通知タイプ（wake_up, breakfast など）
  def send_notification(user, notification_type)
    # インスタンス変数にユーザー情報を格納
    @user = user

    # インスタンス変数に通知タイプを格納
    @notification_type = notification_type

    # メール送信用に新しいワンタイムトークンを発行して保存する
    @user.generate_one_time_token!

    # メール本文に記載するワンタイムURLを生成する
    @url = token_authentication_url(token: @user.token)

    # 通知タイプに応じた件名を取得
    subject = notification_subject(notification_type)

    # メールを送信
    mail(to: @user.email, subject: subject)
  end

  private

  # 【修正】通知タイプに応じた件名を返すメソッド
  def notification_subject(notification_type)
    # 対応表から件名を取得し、該当がなければデフォルトの件名を返す
    NOTIFICATION_SUBJECTS.fetch(notification_type, '水分摂取のお知らせ')
  end
end
