# frozen_string_literal: true

# db/migrate/20260718200233_add_notification_time_to_users.rb
# User テーブルに notification_time カラムを追加するマイグレーションファイル
class AddNotificationTimeToUsers < ActiveRecord::Migration[7.0]
  def change
    # users テーブルに notification_time カラムを追加
    # データ型: time（時刻のみを保存）
    # デフォルト値: なし（初回は未設定）
    # NULL 許可: あり（初回は未設定のため）
    add_column :users, :notification_time, :time
  end
end