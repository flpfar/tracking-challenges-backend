class CreateDays < ActiveRecord::Migration[6.0]
  def change
    create_table :days do |t|
      t.date :date, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :reviewed, default: 0
      t.integer :learned, default: 0

      t.timestamps
    end
  end
end
