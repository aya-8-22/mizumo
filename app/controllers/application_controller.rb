# frozen_string_literal: true

# app/controllers/application_controller.rb
# 全コントローラーの基底クラス
# ログイン認証とDeviseのパラメーター設定を管理
class ApplicationController < ActionController::Base
  # ログインしていないユーザーをログインページにリダイレクト
  before_action :authenticate_user!

  # Deviseのコントローラーが呼ばれる前に configure_permitted_parameters を実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  # トークン経由でログインしたユーザーのアクセス範囲を制限するフィルタを実行する
  # 【修正】ログインしている（かつトークン認証された）場合のみアクセス制限フィルターを走らせる
  before_action :restrict_token_authenticated_user_access!, if: :user_signed_in?

  # protected メソッド(このクラスと継承先のクラスからのみ呼び出せる)
  protected

  # Devise のストロングパラメーターを設定するメソッド
  # セキュリティのため、許可されたパラメーターのみを受け取る
  def configure_permitted_parameters
    # サインアップ時に weight と terms_of_service パラメーターを許可
    # weight は任意入力だが、入力された場合は保存できるようにする
    # terms_of_service は必須入力（バリデーションで制御）
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[weight terms_of_service])

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

  private

  # トークン経由でログインした場合、許可されたコントローラー（飲水記録・カレンダー）以外へのアクセスを制限するメソッド
  def restrict_token_authenticated_user_access!
    # セッションにトークン認証済みのフラグがあり、かつ、現在のコントローラーが許可されたものでない場合の処理
    return unless session[:token_authenticated] && !token_accessible_controller?

    # セッションのフラグをクリアする
    session.delete(:token_authenticated)
    # ユーザーに注意を促すアラートを設定する
    flash[:alert] = t('controllers.application.security_alert')
    # 安全のため一旦ログアウトさせるか、通常ログイン画面へ誘導する
    sign_out(current_user) if user_signed_in?
    # ログイン画面へリダイレクトする
    redirect_to new_user_session_path
  end

  # トークン経由でアクセスが許可されているコントローラーのリストを判定するメソッド
  def token_accessible_controller?
    # 【修正】リクエストスペックやテスト環境でも確実に判定できるよう、コントローラー名文字列（controller_name）で比較するように修正
    # Railsの controller_name は単数形を返すため "water_intake", "calendar" で判定する
    controller_name.in?(%w[water_intake calendar])
  end
end
