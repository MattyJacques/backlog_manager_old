class CreatePlatformFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_families do |t|
      t.string :name

      t.timestamps
    end
  end
end
