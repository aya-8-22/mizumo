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
    @show_next_button = false

    # 初回表示時（体重未登録時）は modal レイアウトを使用
    render layout: 'modal' if @user.weight.blank?
  end

  # PATCH/PUT /weight_setting
  # 体重を更新
  def update
    # ログインしているユーザーの情報を取得
    @user = current_user

    # 体重が空の場合はエラーメッセージを表示
    if weight_params[:weight].blank?
      # 【修正】エラー処理をメソッドに分割
      handle_weight_blank_error
      return
    end

    # 【修正】初回保存かどうかを判定（更新前の体重が空かどうか）
    first_time = @user.weight.blank?

    # ユーザーの体重を更新
    if @user.update(weight_params)
      # 【修正】保存成功時の処理をメソッドに分割
      handle_weight_update_success(first_time)
    else
      # 【修正】保存失敗時の処理をメソッドに分割
      handle_weight_update_failure(first_time)
    end
  end

  private

  # Strong Parameters で許可するパラメータを定義
  def weight_params
    params.require(:user).permit(:weight)
  end

  # 【修正】体重が空の場合のエラー処理
  def handle_weight_blank_error
    # バリデーションエラーメッセージを追加
    @user.errors.add(:weight, 'を入力してください')

    # エラー時は「次へ」ボタンを表示しない
    @show_next_button = false

    # エラー画面を表示
    render :edit, layout: (@user.weight.blank? ? 'modal' : 'application'), status: :unprocessable_entity
  end

  # 【修正】体重更新成功時の処理
  def handle_weight_update_success(first_time)
    # 保存成功時は「次へ」ボタンの表示を判定
    @show_next_button = first_time

    # 保存成功時は常にフラッシュメッセージを表示
    flash.now[:success] = t('.update.success')

    # 初回保存時は modal レイアウトで再表示
    # 2回目以降は application レイアウトで再表示
    render :edit, layout: (first_time ? 'modal' : 'application')
  end

  # 【修正】体重更新失敗時の処理
  def handle_weight_update_failure(first_time)
    # 保存失敗時は「次へ」ボタンを表示しない
    @show_next_button = false

    # エラー画面を表示
    render :edit, layout: (first_time ? 'modal' : 'application'), status: :unprocessable_entity
  end
end
