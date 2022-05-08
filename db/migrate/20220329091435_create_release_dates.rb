class CreateReleaseDates < ActiveRecord::Migration[7.0]
  def change
    create_table :release_dates do |t|
      t.date :date
      t.belongs_to :game, null: false, foreign_key: true
      t.belongs_to :platform, null: false, foreign_key: true

      t.timestamps
    end
  end
end
