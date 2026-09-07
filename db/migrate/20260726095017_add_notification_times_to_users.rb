# 【修正】db/migrate/20260726095017_add_notification_times_to_users.rb
class AddNotificationTimesToUsers < ActiveRecord::Migration[7.0]
  def change
    # 【修正】各時間帯のカラムを追加（デフォルト値あり）
    add_column :users, :wake_up_time, :time, default: '06:00'
    add_column :users, :breakfast_time, :time, default: '08:00'
    add_column :users, :morning_time, :time, default: '10:00'
    add_column :users, :lunch_time, :time, default: '12:00'
    add_column :users, :afternoon_time, :time, default: '15:00'
    add_column :users, :bath_time, :time, default: '17:00'
    add_column :users, :dinner_time, :time, default: '19:00'
    add_column :users, :bedtime, :time, default: '21:00'
    
    # 【修正】各時間帯のオン・オフフラグを追加（デフォルトはすべてオン）
    add_column :users, :wake_up_enabled, :boolean, default: true
    add_column :users, :breakfast_enabled, :boolean, default: true
    add_column :users, :morning_enabled, :boolean, default: true
    add_column :users, :lunch_enabled, :boolean, default: true
    add_column :users, :afternoon_enabled, :boolean, default: true
    add_column :users, :bath_enabled, :boolean, default: true
    add_column :users, :dinner_enabled, :boolean, default: true
    add_column :users, :bedtime_enabled, :boolean, default: true
  end
end