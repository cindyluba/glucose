class ContinuousGlucoseLevel < ApplicationRecord
    belongs_to :member

    validates :value, :tested_at, :tz_offset, presence: true

    def get_local_time
        tested_at.getlocal(tz_offset)
    end
end
