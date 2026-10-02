# frozen_string_literal: true

# 【追加】app/controllers/contacts_controller.rb
# お問い合わせに関する処理（フォーム表示や送信など）を行うコントローラー

# お問い合わせ機能全体をコントロールするクラスを定義する
class ContactsController < ApplicationController
  # ログインしていないユーザーでもお問い合わせを利用できるように認証をスキップする
  skip_before_action :authenticate_user!, only: %i[new create complete]

  # お問い合わせ入力画面を表示するアクション
  def new
    # ビューでフォームを構築するための空のContactオブジェクトを作成する
    @contact = Contact.new
  end

  # お問合わせフォームから送信されたデータを受け取って処理するアクション
  def create
    # フォームから送られてきたパラメータを使ってContactオブジェクトを再生成する
    @contact = Contact.new(contact_params)

    # モデルのバリデーションチェックを実行し、成功した場合のみ処理を進める
    if @contact.valid?
      # 管理者宛とユーザー宛にそれぞれメールを送信する処理を実行する
      ContactMailer.send_admin(@contact).deliver_now
      # ContactMailer.send_user(@contact).deliver_now

      # メール送信が完了したら送信完了画面へリダイレクトし、成功メッセージを表示する
      redirect_to contact_complete_path, notice: 'お問い合わせを受け付けました。'
    else
      # バリデーションエラーがある場合は入力画面を再度表示する
      render :new, status: :unprocessable_entity
    end
  end

  # お問い合わせ送信完了画面を表示するアクション
  def complete
    # 完了画面の表示に必要な処理（特別なデータ取得は不要なため空）
  end

  private

  # セキュリティのため、フォームから送信されるパラメータを安全に絞り込むストロングパラメータ
  def contact_params
    # contactキーの中にある許可された属性のみを受け取るように制限する
    params.require(:contact).permit(:name, :email, :relationship, :category, :message, :terms_of_service)
  end
end