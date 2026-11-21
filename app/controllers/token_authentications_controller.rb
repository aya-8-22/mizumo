# frozen_string_literal: true

# app/controllers/token_authentications_controller.rb
# ワンタイムURLによる自動ログイン処理を管理するコントローラー
class TokenAuthenticationsController < ApplicationController
  # ログインしていなくてもアクセスできるように認証フィルタをスキップする
  skip_before_action :authenticate_user!, raise: false

  # トークン認証コントローラー自体では、トークン認証用のアクセス制限フィルタを実行しないようにスキップする
  skip_before_action :restrict_token_authenticated_user_access!, raise: false

  # 【修正】メール内のリンク（GET）からアクセスされた際は、トークンを消費せず「確認画面」を表示する
  def show
    # トークンからユーザーを取得
    user = find_token_user
    # 見つからなければ無効トークンとして処理
    return redirect_with_invalid_token unless user

    # 確認画面表示用にトークンを保持
    @token = params[:token]
    # モーダル専用レイアウトで表示
    render layout: 'modal'
  end

  # 【修正】確認画面のボタンが押された時（POST）に、はじめてトークンを検証・消費してログインするアクション
  def create
    # トークンからユーザーを取得
    user = find_token_user
    # 見つからなければ無効トークンとして処理
    return redirect_with_invalid_token unless user

    # トークンを無効化(同時実行対策)
    return redirect_with_already_used unless consume_token?(user)

    # ログイン状態にする
    sign_in(user)
    # トークン経由ログインのフラグを立てる
    session[:token_authenticated] = true
    # 成功メッセージをセット
    flash[:notice] = t('controllers.token_authentications.success')
    # 飲水記録画面へ遷移
    redirect_to water_intakes_path
  end

  private

  # トークンからユーザーを検索(show/createで共通利用)
  def find_token_user
    # トークンでユーザーを検索
    user = User.find_by(token: params[:token])
    # 存在しない、または期限切れならnilを返す
    return nil if user.nil? || user.token_expired?

    # 有効なユーザーを返す
    user
  end

  # トークンを1回限りに無効化する
  def consume_token?(user)
    # rubocop:disable Rails/SkipsModelValidations
    # 原子的に更新し、競合を更新件数で検知
    updated_count = User.where(id: user.id, token: params[:token]).update_all(token: nil, token_expires_at: nil)
    # rubocop:enable Rails/SkipsModelValidations
    # 更新件数が1件なら成功
    updated_count == 1
  end

  # 無効トークン時のリダイレクト処理
  def redirect_with_invalid_token
    # エラーメッセージをセット
    flash[:alert] = t('controllers.token_authentications.invalid_token')
    # ログイン画面へ遷移
    redirect_to new_user_session_path
  end

  # 使用済みトークン時のリダイレクト処理
  def redirect_with_already_used
    # エラーメッセージをセット
    flash[:alert] = t('controllers.token_authentications.already_used')
    # ログイン画面へ遷移
    redirect_to new_user_session_path
  end
end
