# frozen_string_literal: true

# app/controllers/password_settings_controller.rb
# 設定（パスワード変更）画面のコントローラー
# ログイン中のユーザーがパスワードを変更するための処理を担当

class PasswordSettingsController < ApplicationController
  # ログインしていないユーザーはアクセスできないようにする
  before_action :authenticate_user!

  # パスワード変更画面を表示するアクション
  # GET /password_setting/edit
  def edit
    # 現在ログイン中のユーザー（current_user）を取得
    # edit.html.erb で使用するため、@user に代入
    @user = current_user
  end

  # 【修正】パスワード変更処理を実行するアクション
  # PATCH /password_setting
  def update
    # 現在ログイン中のユーザー（current_user）を取得
    @user = current_user

    # 【修正】新しいパスワードが空欄かどうかをチェック
    # password_params[:password] が空欄の場合、バリデーションエラーを追加
    if password_params[:password].blank?
      # 【修正】エラーメッセージを @user.errors に追加
      # :password は、エラーが発生したフィールドを指定
      # 第二引数は、エラーメッセージの内容
      @user.errors.add(:password, I18n.t('errors.messages.blank'))
      # 【修正】edit.html.erb を再度表示
      # status: :unprocessable_entity は、422エラー(処理できないエンティティ)を返す
      render :edit, status: :unprocessable_entity
      # 【修正】return で処理を終了し、以降のコードを実行しないようにする
      return
    end

    # Devise の update_with_password メソッドを使用してパスワードを更新
    # このメソッドは「現在のパスワード」「新しいパスワード」「新しいパスワード（確認）」の3つを検証する
    # 検証に成功した場合は true、失敗した場合は false を返す
    if @user.update_with_password(password_params)
      # パスワード更新成功時の処理

      # Devise では、パスワード変更後にセッションが無効化されるため、再度ログインさせる
      # bypass_sign_in は、パスワード変更後に自動的に再ログインさせるための Devise のメソッド
      bypass_sign_in(@user)

      # フラッシュメッセージを設定
      # i18n の翻訳ファイル（config/locales/ja.yml）から success メッセージを取得
      flash[:notice] = t('.success')

      # パスワード変更完了画面にリダイレクト
      redirect_to password_settings_complete_path
    else
      # パスワード更新失敗時の処理
      # flash.now[:alert] = t('password_settings.update.failure') # 【追加】失敗時のメッセージ
      # バリデーションエラーが発生した場合、edit.html.erb を再度表示
      # status: :unprocessable_entity は、422エラー（処理できないエンティティ）を返す
      render :edit, status: :unprocessable_entity
    end
  end

  # 【修正】パスワード変更完了画面を表示するアクション
  # GET /password_settings/complete
  def complete
    # complete.html.erb を表示するだけのアクション
    # 特に処理は不要
  end

  private

  # Strong Parameters（ストロングパラメータ）
  # フォームから送信されたパラメータのうち、許可されたもののみを受け取るための仕組み
  def password_params
    # params[:user] の中から、以下のキーのみを許可
    # - current_password: 現在のパスワード
    # - password: 新しいパスワード
    # - password_confirmation: 新しいパスワード（確認）
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
