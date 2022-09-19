class CreateReleases < ActiveRecord::Migration[7.0]
  def change
    create_table :releases do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.belongs_to :platform, null: false, foreign_key: true
      t.integer :region, null: false, default: 8
      t.string :psn_communication_id
      t.string :psn_title_id
      t.date :date, null: false

      t.timestamps

      t.index [:game, :platform, :region, :psn_communication_id], unique: true, name: 'unique release index'
    end
  end
end
