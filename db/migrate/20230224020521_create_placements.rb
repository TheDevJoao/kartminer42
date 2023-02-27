class CreatePlacements < ActiveRecord::Migration[7.0]
  def change
    create_table :placements do |t|
      t.integer :position, null: false

      t.references :racer, null: false, foreign_key: true
      t.references :race, null: false, foreign_key: true

      t.index %i[racer_id race_id], unique: true
      t.index %i[position race_id], unique: true

      t.timestamps
    end
  end
end
