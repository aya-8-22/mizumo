# frozen_string_literal: true

# app/mailers/application_mailer.rb
# すべてのメーラーの基底クラス
class ApplicationMailer < ActionMailer::Base
  # 【修正】メールの送信元アドレスをテスト用に設定
  # Resend のテスト用ドメインから送信（独自ドメイン不要）
  # 【注意】独自ドメイン設定後、変更が必要
  default from: 'onboarding@resend.dev'

  # メールのレイアウトを指定
  layout 'mailer'
end