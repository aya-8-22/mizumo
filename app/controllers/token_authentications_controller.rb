# frozen_string_literal: true

# 【追加】app/controllers/token_authentications_controller.rb
# ワンタイムURLによる自動ログイン処理を管理するコントローラー
class TokenAuthenticationsController < ApplicationController
  # ログインしていなくてもアクセスできるように認証フィルタをスキップする
  skip_before_action :authenticate_user!, raise: false

  # 【修正】トークン認証コントローラー自体では、トークン認証用のアクセス制限フィルタを実行しないようにスキップする
  skip_before_action :restrict_token_authenticated_user_access!, raise: false

  # メール内のリンクからアクセスされた際の認証処理を行うアクション
  def show
    # パラメータのトークンに一致するユーザーをデータベースから検索する
    user = User.find_by(token: params[:token])

    # トークンが存在しない、または有効期限切れの場合の処理
    if user.nil? || user.token_expired?
      # エラーメッセージをフラッシュに設定する  '無効なURL、または有効期限（24時間）が切れています。通常ログインを行ってください。'
      flash[:alert] = t('controllers.token_authentications.invalid_token')
      # 通常のログイン画面へリダイレクトする
      redirect_to new_user_session_path
      return
    end

    # 同時リクエスト対策として、該当ユーザーのトークンを一度きりのものとして無効化する
    updated_count = User.where(id: user.id, token: params[:token]).update_all(token: nil, token_expires_at: nil)

    # 他のリクエストと同時に使われてすでに無効化されていた場合のガード処理 'このワンタイムURLはすでに使用されています。'
    unless updated_count == 1
      flash[:alert] = t('controllers.token_authentications.already_used')
      redirect_to new_user_session_path
      return
    end

    # Deviseの機能を使ってユーザーをログイン状態（セッションを生成）にする
    sign_in(user)

    # トークン経由でログインしたことを示すフラグをセッションに保持させ、アクセス範囲を制限する
    session[:token_authenticated] = true

    # ログイン成功のメッセージを設定する '自動でログインしました。'
    flash[:notice] = t('controllers.token_authentications.success')
    # 目的の飲水記録画面へリダイレクトする
    redirect_to water_intakes_path
  end
end
