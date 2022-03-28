class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.integer :igdb_id, null: false
      t.date :release_date

      t.timestamps
    end
  end
end
