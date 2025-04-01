class CreateContinuousGlucoseLevels < ActiveRecord::Migration[8.0]
  def change
    create_table :continuous_glucose_levels do |t|
      t.references :member, null: false, foreign_key: true
      t.integer :value, null: false
      t.datetime :tested_at, null: false
      t.string :tz_offset

      t.timestamps
    end
  end
end
