class CreateTrophyLists < ActiveRecord::Migration[7.0]
  def change
    create_table :trophy_lists do |t|
      t.belongs_to :release, null: false, foreign_key: true
      t.integer :region

      t.timestamps
    end
  end
end
