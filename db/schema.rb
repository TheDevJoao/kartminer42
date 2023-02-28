# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_224_020_521) do
  create_table 'placements', force: :cascade do |t|
    t.integer 'position', null: false
    t.integer 'racer_id', null: false
    t.integer 'race_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[position race_id], name: 'index_placements_on_position_and_race_id', unique: true
    t.index ['race_id'], name: 'index_placements_on_race_id'
    t.index %w[racer_id race_id], name: 'index_placements_on_racer_id_and_race_id', unique: true
    t.index ['racer_id'], name: 'index_placements_on_racer_id'
  end

  create_table 'racers', force: :cascade do |t|
    t.string 'name', null: false
    t.date 'born_at', null: false
    t.string 'image_url'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'races', force: :cascade do |t|
    t.date 'date', null: false
    t.string 'place', null: false
    t.integer 'tournament_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['tournament_id'], name: 'index_races_on_tournament_id'
  end

  create_table 'tournaments', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'placements', 'racers'
  add_foreign_key 'placements', 'races'
  add_foreign_key 'races', 'tournaments'
end
