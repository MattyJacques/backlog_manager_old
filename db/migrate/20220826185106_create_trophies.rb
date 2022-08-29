class CreateTrophies < ActiveRecord::Migration[7.0]
  def change
    create_table :trophies do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.integer :psn_id, null: false
      t.string :name, null: false
      t.string :detail, null: false
      t.string :icon_url, null: false
      t.integer :rank, null: false
      t.boolean :hidden, null: false, default: false
      t.integer :progress_target, default: 1
      t.string :trophy_group
      t.string :reward_name
      t.string :reward_url

      t.timestamps

      t.index [:game_id, :psn_id], unique: true
    end
  end
end
