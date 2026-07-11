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

    # POST /resource/sign_in
    # 【修正】createアクションをコメントアウトして、チェックボックスの状態に応じて remember_me を設定する
    # def create
    #   # 【修正前】remember_me を強制的に有効にする処理を削除
    #   # params[:user][:remember_me] = '1' if params[:user]
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    protected

    # 【追加】ログイン成功後のリダイレクト先を設定
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
