# frozen_string_literal: true

# 文字列リテラルを変更不可にする設定

# 【追加】app/controllers/users/registrations_controller.rb
# Devise が提供するユーザー登録機能をカスタマイズするためのコントローラー
module Users
  class RegistrationsController < Devise::RegistrationsController
    # ユーザー登録時に体重(weight)パラメーターを許可
    before_action :configure_sign_up_params, only: [:create]

    # このクラスとサブクラスからのみアクセス可能なメソッドを定義
    protected

    # ユーザー登録時に許可するパラメーターを設定
    def configure_sign_up_params
      # デフォルトでは email と password のみ許可されているため、weight を追加で許可
      devise_parameter_sanitizer.permit(:sign_up, keys: [:weight])
    end
  end
end
