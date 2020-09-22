class RemoveLearnedAndReviewedFromDays < ActiveRecord::Migration[6.0]
  def change
    remove_column :days, :learned, :integer
    remove_column :days, :reviewed, :integer
  end
end
