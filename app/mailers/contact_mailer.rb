# frozen_string_literal: true

# 【追加】app/mailers/contact_mailer.rb
# お問い合わせに関するメール送信処理を行うクラス

# お問い合わせに関するメール送信を処理するメーラークラスを定義する
class ContactMailer < ApplicationMailer
  # 管理者宛てにお問い合わせ内容のメールを送信するメソッド
  def send_admin(contact)
    # ビューで参照できるようにインスタンス変数にcontactオブジェクトを代入する
    @contact = contact
    # 環境変数またはデフォルトの管理者メールアドレス宛に、件名を設定してメールを送信する
    mail(
      to: ENV.fetch('ALLOWED_NOTIFICATION_EMAIL', 'admin@example.com'),
      reply_to: @contact.email,
      subject: "【お問い合わせ】#{@contact.name}様より（#{@contact.category}）"
    )
  end

  # ユーザー宛てにお問い合わせ受付完了の確認メールを送信するメソッド
  # def send_user(contact)
    # ビューで参照できるようにインスタンス変数にcontactオブジェクトを代入する
    # @contact = contact
    # お問い合わせフォームに入力されたユーザーのメールアドレス宛に受付完了メールを送信する
    # mail(
      # to: @contact.email,
      #subject: '【ミズモ】お問い合わせを受け付けました'
    #)
  #end
end