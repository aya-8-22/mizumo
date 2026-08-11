# frozen_string_literal: true

# app/mailers/application_mailer.rb
# すべてのメーラーの基底クラス
class ApplicationMailer < ActionMailer::Base
  # 【修正】メールの送信元アドレスを設定
  default from: 'noreply@yourapp.com'
  # メールのレイアウトを指定
  layout 'mailer'
end