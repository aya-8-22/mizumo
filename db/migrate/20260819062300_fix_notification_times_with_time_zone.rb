# db/migrate/20260819062300_fix_notification_times_with_time_zone.rb
# 未設定のユーザーの通知時間（起床から就寝まで）を、タイムゾーンを考慮して一括でデフォルト値に修正するマイグレーションファイル

class FixNotificationTimesWithTimeZone < ActiveRecord::Migration[7.0]
  def up
    # notification_times_confirmed が false のユーザーのみが対象
    User.where(notification_times_confirmed: false).find_each do |user|
      # 起床時: 画面表示 06:00 (JST)
      wake_up   = Time.zone.local(2000, 1, 1, 6,  0, 0)
      # 朝食時: 画面表示 08:00 (JST)
      breakfast = Time.zone.local(2000, 1, 1, 8,  0, 0)
      # 10時頃: 画面表示 10:00 (JST)
      morning   = Time.zone.local(2000, 1, 1, 10, 0, 0)
      # 昼食時: 画面表示 12:00 (JST)
      lunch     = Time.zone.local(2000, 1, 1, 12, 0, 0)
      # 15時頃: 画面表示 15:00 (JST)
      afternoon = Time.zone.local(2000, 1, 1, 15, 0, 0)
      # 入浴時: 画面表示 17:00 (JST)
      bath      = Time.zone.local(2000, 1, 1, 17, 0, 0)
      # 夕食時: 画面表示 19:00 (JST)
      dinner    = Time.zone.local(2000, 1, 1, 19, 0, 0)
      # 就寝時: 画面表示 21:00 (JST)
      bed       = Time.zone.local(2000, 1, 1, 21, 0, 0)

      # まとめて1回で更新する（パフォーマンスと可読性の両立）
      user.update_columns(
        wake_up_time:   wake_up,
        breakfast_time: breakfast,
        morning_time:   morning,
        lunch_time:     lunch,
        afternoon_time: afternoon,
        bath_time:      bath,
        dinner_time:    dinner,
        bedtime:        bed
      )
    end
  end

  def down
    # ロールバック時の処理は不要
  end
end