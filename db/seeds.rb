# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'

csv_path = Rails.root.join('db', 'data', 'cgm_data_points.csv')

puts "Seeding ContinuousGlucoseLevels from #{csv_path}..."

CSV.foreach(csv_path, headers: true).with_index(1) do |row, index|
  begin
    tested_at_raw = row['tested_at']
    value_raw = row['value']
    tz_offset_raw = row['tz_offset']

    if tested_at_raw.blank? || value_raw.blank? || tz_offset_raw.blank?
      puts "⚠️  Skipping row #{index}: missing required fields"
      next
    end

    tested_at = DateTime.strptime(tested_at_raw, "%m/%d/%y %H:%M").to_time

    ContinuousGlucoseLevel.create!(
      member_id: 1,
      tested_at: tested_at,
      value: value_raw.to_i,
      tz_offset: tz_offset_raw
    )
  rescue => e
    puts "❌ Failed to process row #{index}: #{e.message}"
  end
end

puts "✅ Seeding complete."