class Race < ApplicationRecord
  belongs_to :tournament

  has_many :placements, dependent: :destroy

  has_many :racers, through: :placements

  validates :date,
            presence: true

  validates :place,
            presence: true

  scope :race_result, -> { order('races.date ASC, position ASC') }
end
