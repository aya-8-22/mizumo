class AddTimeSlotToWaterIntakes < ActiveRecord::Migration[7.0]
  def change
    add_column :water_intakes, :time_slot, :string
  end
end
