class RemoveAmountFromWaterIntakes < ActiveRecord::Migration[7.0]
  def change
    remove_column :water_intakes, :amount, :integer
  end
end
