# frozen_string_literal: true

# app/controllers/users/sessions_controller.rb
# ユーザーがログイン・ログアウトする際の具体的な処理や手順を制御する司令

module Users
  # Deviseという既存の便利なログイン機能（Devise::SessionsController）を継承して、自分好みにカスタマイズできるようにした新しい司令塔
  class SessionsController < Devise::SessionsController
    # ログイン前にメール通知からのアクセスを判定
    before_action :check_from_email_notification, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # 【修正】POST /resource/sign_in
    def create
      # 親クラスのログイン処理を実行してユーザー情報を取得
      self.resource = warden.authenticate(auth_options)
      # 認証失敗(resourceがnil)の場合は、専用メソッドで処理して以降を抜ける
      return handle_failed_login unless resource

      # ログイン成功メッセージを設定
      set_flash_message!(:notice, :signed_in)
      # ユーザーをログイン状態にする
      sign_in(resource_name, resource)
      # ブロックが渡されていれば実行する
      yield resource if block_given?
      # ログイン成功後のリダイレクト先に遷移
      respond_with resource, location: after_sign_in_path_for(resource)
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    private

    # 【修正】ログイン失敗時の処理をまとめたメソッド
    def handle_failed_login
      # エラーメッセージ表示用に新しいユーザーオブジェクトを作成する
      self.resource = resource_class.new(sign_in_params)
      # baseエラーとしてinvalid_loginメッセージを追加する
      resource.errors.add(:base, :invalid_login)
      # ログイン画面を再表示する(422ステータスコードで返す)
      render :new, status: :unprocessable_entity
    end

    # ログイン成功後のリダイレクト先を設定
    # ログイン成功後は記録画面に遷移
    def after_sign_in_path_for(_resource)
      # メール通知からのアクセスの場合はセッションを削除
      session.delete(:from_email_notification)
      # 記録画面にリダイレクト
      water_intakes_path
    end

    # メール通知からのアクセスを判定するメソッド
    def check_from_email_notification
      # パラメータに from_email が含まれている場合
      return unless params[:from_email] == 'true'

      # セッションに from_email_notification を保存
      session[:from_email_notification] = true
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
