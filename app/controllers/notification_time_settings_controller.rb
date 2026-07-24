# app/controllers/notification_time_settings_controller.rb
# 通知時間設定を管理するコントローラー
class NotificationTimeSettingsController < ApplicationController
  # 通知時間設定画面を表示
  def edit
    # 現在ログインしているユーザー情報を取得
    @user = current_user
  end

  # 通知時間を更新する処理
  def update
    # 現在ログインしているユーザー情報を取得
    @user = current_user
    
    # 初回かどうかを判定(notification_timeが空なら初回)
    first_time = @user.notification_time.blank?

    # 通知時間を保存する処理
    if @user.update(notification_time_params)
      # 初回の場合:記録画面に遷移
      if first_time
        redirect_to water_intakes_path, notice: '通知時間を登録しました'
      else
        # 2回目以降の場合:同じ画面に留まる
        flash.now[:notice] = '通知時間を更新しました'
        render :edit
      end
    else
      # 保存失敗時:同じ画面を再表示
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # 通知時間パラメータを許可
  def notification_time_params
    # notification_timeカラムのみを許可
    params.require(:user).permit(:notification_time)
  end
end