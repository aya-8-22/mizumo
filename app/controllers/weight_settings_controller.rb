# frozen_string_literal: true

# app/controllers/weight_settings_controller.rb
# 「体重設定画面」に関する処理を担当するコントローラー
class WeightSettingsController < ApplicationController
  # ログインしているユーザーのみアクセス可能
  before_action :authenticate_user!

  # GET /weight_setting/edit
  # 体重設定画面を表示
  def edit
    # ログインしているユーザーの情報を取得
    @user = current_user

    # 【修正】初回表示時は @show_next_button を false に設定
    # 初回表示時は「次へ」ボタンを表示しない
    @show_next_button = false

    # 初回表示時（体重未登録時）は modal レイアウトを使用
    # @user.weight.blank? が true の場合、体重が未登録
    # 体重が未登録の場合は、モーダル表示にする
    render layout: 'modal' if @user.weight.blank?
  end

  # PATCH/PUT /weight_setting
  # 体重を更新
  def update
    # ログインしているユーザーの情報を取得
    @user = current_user

    # 体重が空の場合はエラーメッセージを表示
    if weight_params[:weight].blank?
      # バリデーションエラーメッセージを追加
      @user.errors.add(:weight, 'を入力してください')

      # エラー時は「次へ」ボタンを表示しない
      @show_next_button = false

      # エラー画面を表示
      render :edit, layout: (@user.weight.blank? ? 'modal' : 'application'), status: :unprocessable_entity
      return
    end

    # 【修正】初回保存かどうかを判定（更新前の体重が空かどうか）
    first_time = @user.weight.blank?

    # ユーザーの体重を更新
    if @user.update(weight_params)
      # 【修正】保存成功時は「次へ」ボタンの表示を判定
      # 初回保存時は true（「次へ」ボタンを表示）
      # 2回目以降は false（「次へ」ボタンを表示しない）
      @show_next_button = first_time

      # 【修正】保存成功時は常にフラッシュメッセージを表示
      flash.now[:success] = '体重を保存しました'

      # 初回保存時は modal レイアウトで再表示
      # 2回目以降は application レイアウトで再表示
      render :edit, layout: (first_time ? 'modal' : 'application')
    else
      # 保存失敗時は「次へ」ボタンを表示しない
      @show_next_button = false

      # エラー画面を表示
      render :edit, layout: (first_time ? 'modal' : 'application'), status: :unprocessable_entity
    end
  end

  private

  # Strong Parameters で許可するパラメータを定義
  # params.require(:user) で user パラメータを必須にする
  # permit(:weight) で weight パラメータのみを許可する
  # これにより、不正なパラメータの送信を防ぐ
  def weight_params
    params.require(:user).permit(:weight)
  end
end