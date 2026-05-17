# frozen_string_literal: true

# app/controllers/application_controller.rb
# 全コントローラーの基底クラス
# ログイン認証とDeviseのパラメーター設定を管理
class ApplicationController < ActionController::Base
  # ログインしていないユーザーをログインページにリダイレクト
  before_action :authenticate_user!

  # Deviseのコントローラーが呼ばれる前に configure_permitted_parameters を実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  # protected メソッド(このクラスと継承先のクラスからのみ呼び出せる)
  protected

  # Devise のストロングパラメーターを設定するメソッド
  # セキュリティのため、許可されたパラメーターのみを受け取る
  def configure_permitted_parameters
    # サインアップ時に weight パラメーターを許可
    # permit(:sign_up, keys: [:weight]) で weight を受け取れるようにする
    devise_parameter_sanitizer.permit(:sign_up, keys: [:weight])

    # アカウント更新時に weight パラメーターを許可
    # permit(:account_update, keys: [:weight]) で weight を更新できるようにする
    devise_parameter_sanitizer.permit(:account_update, keys: [:weight])
  end

  # ログイン後のリダイレクト先を制御するメソッド
  # Devise が提供するメソッドをオーバーライド
  def after_sign_in_path_for(_resource)
    # メール通知からのログインの場合はセッションをクリア
    session.delete(:from_email_notification) if session[:from_email_notification]

    # 常に飲水記録ページへリダイレクト
    water_intakes_path
  end
end
