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

    # 【修正】16行あった2つのループ処理を、それぞれ1行の呼び出しに置き換える
    build_time_params!
    cast_enabled_params!

    # 体重のバリデーションをスキップするフラグを設定
    # skip_weight_validation を true にすることで、体重のバリデーションをスキップする
    @user.skip_weight_validation = true

    # 通知時間を更新してバリデーションを実行
    @user.assign_attributes(notification_time_params)

    # 初回の場合は notification_times_confirmed も一緒に更新する
    @user.notification_times_confirmed = true if @first_time

    # バリデーションが成功した場合のみ保存する
    if @user.valid?
      # DBに保存
      @user.save
      # 【変更】リダイレクト先の判定もメソッドに切り出す
      redirect_to success_redirect_path, notice: success_message
    else
      # バリデーション失敗時は編集画面を再表示
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # 【修正】「時」「分」パラメータを結合して時刻パラメータに変換する
  # User::NOTIFICATION_TIME_FIELDS を再利用することで、フィールド定義を一箇所に集約
  def build_time_params!
    User::NOTIFICATION_TIME_FIELDS.each do |field|
      build_time_param_for(field[:time_field])
    end
  end

  # 【修正】1つの時間帯について「時」「分」を結合し、不要なパラメータを削除する
  def build_time_param_for(time_field)
    # パラメータから「時」「分」を取得(例: "wake_up_time_hour" => "8")
    hour = params[:user]["#{time_field}_hour"]
    min = params[:user]["#{time_field}_min"]

    # 「時」と「分」が両方存在する場合のみ時刻を作成
    params[:user][time_field] = Time.zone.parse("#{hour}:#{min}") if hour.present? && min.present?

    # 「時」と「分」のパラメータを削除(不要なため)
    params[:user].delete("#{time_field}_hour")
    params[:user].delete("#{time_field}_min")
  end

  # 【修正】enabled パラメータを boolean 型に変換する
  def cast_enabled_params!
    User::NOTIFICATION_TIME_FIELDS.each do |field|
      enabled_field = field[:enabled_field]
      # Rails の型変換ルールに従って "1"/"0" などを true/false に変換
      params[:user][enabled_field] = ActiveModel::Type::Boolean.new.cast(params[:user][enabled_field])
    end
  end

  # 【修正】保存成功時のリダイレクト先を判定する
  def success_redirect_path
    # 初回なら記録画面、2回目以降なら設定画面に留まる
    @first_time ? water_intakes_path : edit_notification_time_setting_path
  end

  # 【修正】保存成功時のフラッシュメッセージを判定する
  def success_message
    @first_time ? t('.create.success') : t('.update.success')
  end

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
