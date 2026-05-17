# frozen_string_literal: true

# app/controllers/users/sessions_controller.rb
module Users
  class SessionsController < Devise::SessionsController
    # 【修正】ログイン前にメール通知からのアクセスを判定
    before_action :check_from_email_notification, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # 【修正】protected のコメントアウトを解除
    protected

    # 【修正】メール通知からのアクセスを判定するメソッドを追加
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
