class Placement < ApplicationRecord
  belongs_to :racer

  belongs_to :race

  validates :racer_id,
            uniqueness: { scope: :race_id }

  validates :position,
            uniqueness: { scope: :race_id },
            numericality: { only_integer: true },
            presence: true

  scope :get_placements, -> { joins(:race).order('races.id ASC, position ASC, racer_id ASC') }
end
