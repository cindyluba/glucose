class Member < ApplicationRecord
    has_many :continuous_glucose_levels, dependent: :destroy

    validates :first_name, :last_name, presence: true
end
