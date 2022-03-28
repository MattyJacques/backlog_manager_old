class CreatePlatforms < ActiveRecord::Migration[7.0]
  def change
    create_table :platforms do |t|
      t.string :name, null: false
      t.integer :igdb_id, null: false
      t.date :release_date
      t.belongs_to :platform_family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
