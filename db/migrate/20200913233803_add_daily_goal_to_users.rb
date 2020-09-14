class AddDailyGoalToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :daily_goal, :integer, default: 1
  end
end
