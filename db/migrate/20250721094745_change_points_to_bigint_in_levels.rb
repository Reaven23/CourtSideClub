class ChangePointsToBigintInLevels < ActiveRecord::Migration[7.1]
  def change
    change_column :levels, :points, :bigint
  end
end
