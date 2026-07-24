# db/migrate/20260718200233_add_notification_time_to_users.rb
class AddNotificationTimeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notification_time, :time
  end
end
