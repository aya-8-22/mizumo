# db/migrate/20260513031413_add_target_water_intake_to_users.rb
# 目標飲水量カラムを追加するマイグレーションファイル
class AddTargetWaterIntakeToUsers < ActiveRecord::Migration[7.0]
  def change
    # users テーブルに target_water_intake カラムを追加
    # デフォルト値: 2000ml（一般的な推奨量）
    # null: false で必須項目に設定
    add_column :users, :target_water_intake, :integer, default: 2000, null: false
  end
end