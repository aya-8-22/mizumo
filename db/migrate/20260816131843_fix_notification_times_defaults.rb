# db/migrate/20260816131843_fix_notification_times_defaults.rb
# 通知時間のデフォルト値を修正するマイグレーション
class FixNotificationTimesDefaults < ActiveRecord::Migration[7.0]
  def up
    # 既存のユーザーで通知時間を未設定のユーザーの時間を修正
    # notification_times_confirmed が false のユーザーのみが対象
    User.where(notification_times_confirmed: false).find_each do |user|
      # 起床時: 画面表示 06:00 (JST) → データベース保存 21:00 (UTC 前日)
      user.update_column(:wake_up_time, '21:00:00')
      
      # 朝食時: 画面表示 08:00 (JST) → データベース保存 23:00 (UTC 前日)
      user.update_column(:breakfast_time, '23:00:00')
      
      # 10時頃: 画面表示 10:00 (JST) → データベース保存 01:00 (UTC)
      user.update_column(:morning_time, '01:00:00')
      
      # 昼食時: 画面表示 12:00 (JST) → データベース保存 03:00 (UTC)
      user.update_column(:lunch_time, '03:00:00')
      
      # 15時頃: 画面表示 15:00 (JST) → データベース保存 06:00 (UTC)
      user.update_column(:afternoon_time, '06:00:00')
      
      # 入浴時: 画面表示 17:00 (JST) → データベース保存 08:00 (UTC)
      user.update_column(:bath_time, '08:00:00')
      
      # 夕食時: 画面表示 19:00 (JST) → データベース保存 10:00 (UTC)
      user.update_column(:dinner_time, '10:00:00')
      
      # 就寝時: 画面表示 21:00 (JST) → データベース保存 12:00 (UTC)
      user.update_column(:bedtime, '12:00:00')
    end

    # 新規登録時のデフォルト値を修正
    # 起床時: 画面表示 06:00 (JST) → データベース保存 21:00 (UTC 前日)
    change_column_default :users, :wake_up_time, from: '2000-01-01 06:00:00', to: '2000-01-01 21:00:00'
    
    # 朝食時: 画面表示 08:00 (JST) → データベース保存 23:00 (UTC 前日)
    change_column_default :users, :breakfast_time, from: '2000-01-01 08:00:00', to: '2000-01-01 23:00:00'
    
    # 10時頃: 画面表示 10:00 (JST) → データベース保存 01:00 (UTC)
    change_column_default :users, :morning_time, from: '2000-01-01 10:00:00', to: '2000-01-01 01:00:00'
    
    # 昼食時: 画面表示 12:00 (JST) → データベース保存 03:00 (UTC)
    change_column_default :users, :lunch_time, from: '2000-01-01 12:00:00', to: '2000-01-01 03:00:00'
    
    # 15時頃: 画面表示 15:00 (JST) → データベース保存 06:00 (UTC)
    change_column_default :users, :afternoon_time, from: '2000-01-01 15:00:00', to: '2000-01-01 06:00:00'
    
    # 入浴時: 画面表示 17:00 (JST) → データベース保存 08:00 (UTC)
    change_column_default :users, :bath_time, from: '2000-01-01 17:00:00', to: '2000-01-01 08:00:00'
    
    # 夕食時: 画面表示 19:00 (JST) → データベース保存 10:00 (UTC)
    change_column_default :users, :dinner_time, from: '2000-01-01 19:00:00', to: '2000-01-01 10:00:00'
    
    # 就寝時: 画面表示 21:00 (JST) → データベース保存 12:00 (UTC)
    change_column_default :users, :bedtime, from: '2000-01-01 21:00:00', to: '2000-01-01 12:00:00'
  end

  def down
    # ロールバック時の処理 (元のデフォルト値に戻す)
    # 起床時を元に戻す
    change_column_default :users, :wake_up_time, from: '2000-01-01 21:00:00', to: '2000-01-01 06:00:00'
    
    # 朝食時を元に戻す
    change_column_default :users, :breakfast_time, from: '2000-01-01 23:00:00', to: '2000-01-01 08:00:00'
    
    # 10時頃を元に戻す
    change_column_default :users, :morning_time, from: '2000-01-01 01:00:00', to: '2000-01-01 10:00:00'
    
    # 昼食時を元に戻す
    change_column_default :users, :lunch_time, from: '2000-01-01 03:00:00', to: '2000-01-01 12:00:00'
    
    # 15時頃を元に戻す
    change_column_default :users, :afternoon_time, from: '2000-01-01 06:00:00', to: '2000-01-01 15:00:00'
    
    # 入浴時を元に戻す
    change_column_default :users, :bath_time, from: '2000-01-01 08:00:00', to: '2000-01-01 17:00:00'
    
    # 夕食時を元に戻す
    change_column_default :users, :dinner_time, from: '2000-01-01 10:00:00', to: '2000-01-01 19:00:00'
    
    # 就寝時を元に戻す
    change_column_default :users, :bedtime, from: '2000-01-01 12:00:00', to: '2000-01-01 21:00:00'
  end
end
