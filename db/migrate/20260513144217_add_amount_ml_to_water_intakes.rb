class AddAmountMlToWaterIntakes < ActiveRecord::Migration[7.0]
  def change
    add_column :water_intakes, :amount_ml, :integer
  end
end
