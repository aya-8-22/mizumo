# db/migrate/20260722060031_change_weight_precision_in_users.rb
class ChangeWeightPrecisionInUsers < ActiveRecord::Migration[7.0]
  def change
    # weight カラムの precision と scale を変更
    # precision: 4 → 整数部3桁 + 小数部1桁 = 合計4桁
    # scale: 1 → 小数点以下1桁
    # 最大値: 999.9
    change_column :users, :weight, :decimal, precision: 4, scale: 1
  end
end
