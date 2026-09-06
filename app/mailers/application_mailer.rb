# frozen_string_literal: true

# app/mailers/application_mailer.rb
# すべてのメーラーの基底クラス
class ApplicationMailer < ActionMailer::Base
  # 【修正】独自ドメインの認証が完了したため送信元アドレスを本番用に変更
  default from: 'info@mizumo-app.com'

  # メールのレイアウトを指定
  layout 'mailer'
end