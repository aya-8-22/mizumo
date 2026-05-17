# frozen_string_literal: true

# 文字列リテラルを変更不可にする設定

# app/controllers/users/registrations_controller.rb
# Devise が提供するユーザー登録機能をカスタマイズするためのコントローラー
module Users
  class RegistrationsController < Devise::RegistrationsController
    # ユーザー登録時に体重(weight)パラメーターを許可
    before_action :configure_sign_up_params, only: [:create]
    # ユーザー更新時に体重(weight)パラメーターを許可
    before_action :configure_account_update_params, only: [:update]

    # このクラスとサブクラスからのみアクセス可能なメソッドを定義
    protected

    # ユーザー登録時に許可するパラメーターを設定
    def configure_sign_up_params
      # デフォルトでは email と password のみ許可されているため、weight を追加で許可
      devise_parameter_sanitizer.permit(:sign_up, keys: [:weight])
    end

    # ユーザー更新時に許可するパラメーターを設定
    def configure_account_update_params
      # デフォルトでは email と password のみ許可されているため、weight を追加で許可
      devise_parameter_sanitizer.permit(:account_update, keys: [:weight])
    end

    # 更新成功時のリダイレクト先を記録画面に変更
    def after_update_path_for(_resource)
      # 記録画面へリダイレクト
      water_intakes_path
    end

    # 【追加】更新処理をカスタマイズ(パスワードが空欄の場合はパスワードの検証をスキップ)
    def update_resource(resource, params)
      # パスワードが空欄かどうかを判定
      if params[:password].blank?
        # 【修正】パスワードが空欄の場合は、パスワードの検証をスキップして更新
        # update_without_password メソッドを使用
        # params.except(:current_password) で current_password を除外
        resource.update_without_password(params.except(:current_password))
      else
        # 【修正】パスワードが入力されている場合は、通常の更新処理
        # update_with_password メソッドを使用(現在のパスワードの検証あり)
        resource.update_with_password(params)
      end
    end
  end
end
