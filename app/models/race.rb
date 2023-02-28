class Race < ApplicationRecord
  belongs_to :tournament

  has_many :placements, dependent: :destroy

  has_many :racers, through: :placements

  validates :date,
            presence: true

  validates :place,
            presence: true

accepts_nested_attributes_for :placements,
                              reject_if: proc { |attributes|
                                attributes['racer_id'].blank? || attributes['position'].blank?
                              }, allow_destroy: true         

  scope :race_result, -> { order('races.date ASC, position ASC') }
end
