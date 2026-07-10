# frozen_string_literal: true

# app/controllers/users/registrations_controller.rb
# Deviseのユーザー登録機能をカスタマイズするコントローラー
module Users
  class RegistrationsController < Devise::RegistrationsController
    # ユーザー更新時に体重(weight)パラメーターを許可
    before_action :configure_account_update_params, only: [:update]
    # 【追加】利用規約への同意をチェック
    before_action :check_terms_of_service, only: [:create]

    # 登録完了画面を表示するアクション
    def complete
      # 登録完了画面のビューを表示
    end

    protected

    # 新規登録後のリダイレクト先を登録完了画面に変更
    def after_sign_up_path_for(_resource)
      # 登録完了画面にリダイレクト
      users_registration_complete_path
    end

    # 【追加】新規登録後のログイン時のリダイレクト先を登録完了画面に変更
    def after_sign_in_path_for(resource)
      # 新規登録直後かどうかを判定
      # resource.created_at が1分以内の場合は新規登録直後と判断
      if resource.created_at > 1.minute.ago
        # 新規登録完了画面にリダイレクト
        users_registration_complete_path
      else
        # それ以外の場合は通常のログイン後の遷移先を呼び出す
        # super で親クラス(ApplicationController)の after_sign_in_path_for を呼び出す
        super
      end
    end

    # Strong Parametersに仮想属性を追加
    def sign_up_params
      # terms_of_service を許可するパラメータに追加
      params.require(:user).permit(:email, :password, :password_confirmation, :terms_of_service)
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

    # 更新処理をカスタマイズ(パスワードが空欄の場合はパスワードの検証をスキップ)
    def update_resource(resource, params)
      # パスワードが空欄かどうかを判定
      if params[:password].blank?
        # パスワードが空欄の場合は、パスワードの検証をスキップして更新
        resource.update_without_password(params.except(:current_password))
      else
        # パスワードが入力されている場合は、通常の更新処理
        resource.update_with_password(params)
      end
    end

    private

    # 【追加】利用規約への同意をチェックするメソッド
    def check_terms_of_service
      # 利用規約に同意済みなら何もしない
      return if params.dig(:user, :terms_of_service) == '1'

      # エラーメッセージを設定
      flash[:alert] = t('users.registrations.terms_not_agreed')
      # 新規登録画面に戻る
      redirect_to new_user_registration_path
    end
  end
end
