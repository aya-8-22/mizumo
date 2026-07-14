# （仮）app/controllers/password_settings_controller.rb
class PasswordSettingsController < ApplicationController
  # ログインしているユーザーのみアクセス可能
  before_action :authenticate_user!

  # 編集画面を表示
  def edit
    # current_user が Devise で提供される現在のログインユーザー
  end

  # パスワードを更新
  def update
    # Devise の update_with_password メソッドを使用
    # 現在のパスワードと新しいパスワードの両方をチェック
    if current_user.update_with_password(password_params)
      # バイパスサインインで再ログインを不要に
      bypass_sign_in(current_user)
      redirect_to edit_user_registration_path, notice: t('.success')
    else
      # バリデーションエラーがあれば編集画面を再表示
      flash.now[:alert] = t('.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(
      :current_password,        # 現在のパスワード（必須）
      :password,                # 新しいパスワード
      :password_confirmation    # 新しいパスワード（確認）
    )
  end
end
