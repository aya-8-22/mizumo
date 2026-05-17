# 【追加】db/migrate/20260513024916_create_water_intakes.rb
# 飲水記録テーブルを作成するマイグレーションファイル
class CreateWaterIntakes < ActiveRecord::Migration[7.0]
  # マイグレーションを実行する処理を定義
  def change
    # water_intakes テーブルを作成
    create_table :water_intakes do |t|
      # ユーザーID（外部キー、必須項目）
      t.references :user, null: false, foreign_key: true
      # 飲水量（整数型、必須項目）
      t.integer :amount, null: false
      # 記録日時（日時型、必須項目）
      t.datetime :recorded_at, null: false
      # 作成日時・更新日時のカラムを自動追加
      t.timestamps
    end
  end
end

