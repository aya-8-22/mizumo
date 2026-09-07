# db/migrate/20260727153215_add_notification_times_confirmed_to_users.rb
# 【追加】ユーザーテーブルに初回設定完了フラグを追加するマイグレーション
class AddNotificationTimesConfirmedToUsers < ActiveRecord::Migration[7.0]
  def change
    # 初回設定完了フラグを追加（デフォルトは false = 未設定）
    # notification_times_confirmed というカラムを追加
    # デフォルト値は false（未設定）
    # ユーザーが「保存」ボタンを押したら true に変更
    add_column :users, :notification_times_confirmed, :boolean, default: false, null: false
  end
end
