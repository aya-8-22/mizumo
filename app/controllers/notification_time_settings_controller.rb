# frozen_string_literal: true

# app/controllers/notification_time_settings_controller.rb
# 設定(通知時間)を管理するコントローラー
class NotificationTimeSettingsController < ApplicationController
  # ログイン必須にする
  before_action :authenticate_user!

  # 通知時間設定画面を表示
  def edit
    # 現在ログインしているユーザー情報を取得
    @user = current_user

    # 初回かどうかをインスタンス変数に保存
    # notification_times_confirmed が false なら初回(true)
    # notification_times_confirmed が true なら2回目以降(false)
    @first_time = !@user.notification_times_confirmed
  end

  # 通知時間を更新する処理
  def update
    # 現在ログインしているユーザー情報を取得
    @user = current_user

    # 初回かどうかを判定(最初に判定を保存)
    # この時点で判定を保存しておくことで、バリデーションエラー時も判定が維持される
    # DBの値を使って判定するので、確実に初回かどうかを判定できる
    @first_time = !@user.notification_times_confirmed

    # 【修正】「時」と「分」を結合して時刻を作成
    # 8つの時間帯のフィールド名を配列で定義
    time_fields = [
      :wake_up_time, :breakfast_time, :morning_time, :lunch_time,
      :afternoon_time, :bath_time, :dinner_time, :bedtime
    ]

    # 【修正】各時間帯について「時」と「分」を結合
    time_fields.each do |field|
      # パラメータから「時」を取得(例: "wake_up_time_hour" => "8")
      hour = params[:user]["#{field}_hour"]
      # パラメータから「分」を取得(例: "wake_up_time_min" => "30")
      min = params[:user]["#{field}_min"]
      
      # 「時」と「分」が両方存在する場合のみ時刻を作成
      if hour.present? && min.present?
        # Time.zone.parseで時刻を作成してパラメータに設定(例: "8:30" → Time型に変換)
        params[:user][field] = Time.zone.parse("#{hour}:#{min}")
      end
      
      # 「時」と「分」のパラメータを削除(不要なため)
      params[:user].delete("#{field}_hour")
      params[:user].delete("#{field}_min")
    end

    # まず通知時間だけを更新してバリデーションを実行
    @user.assign_attributes(notification_time_params)

    # バリデーションが成功した場合のみ notification_times_confirmed を true にする
    if @user.valid?
      # バリデーション成功時に notification_times_confirmed を true にする
      @user.notification_times_confirmed = true
      # 保存する
      @user.save

      # @first_time で遷移先を判定
      if @first_time
        # 初回の場合は記録画面へ遷移(メール通知時間を設定しました)
        redirect_to water_intakes_path, notice: t('.create.success')
      else
        # 2回目以降は同じ画面に留まる(メール通知時間を更新しました)
        redirect_to edit_notification_time_setting_path, notice: t('.update.success')
      end
    else
      # バリデーション失敗時
      # @first_time はそのまま維持される(DBの値から判定しているので確実)
      # バリデーションエラー時も初回判定が変わらないので、正しいボタンが表示される
      # render :edit の前に action_name を 'edit' に変更する
      params[:action] = 'edit'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # 通知時間パラメータを許可(8つの時間帯 × 2カラム = 16個)
  def notification_time_params
    # 8つの時間帯の時間とオン・オフを許可
    params.require(:user).permit(
      :wake_up_time, :wake_up_enabled,       # 起床時
      :breakfast_time, :breakfast_enabled,   # 朝食時
      :morning_time, :morning_enabled,       # 10時頃
      :lunch_time, :lunch_enabled,           # 昼食時
      :afternoon_time, :afternoon_enabled,   # 15時頃
      :bath_time, :bath_enabled,             # 入浴時
      :dinner_time, :dinner_enabled,         # 夕食時
      :bedtime, :bedtime_enabled             # 就寝時
    )
  end
end
