require 'uri'

class Racer < ApplicationRecord
  LEGAL_AGE = 18

  has_many :placements

  has_many :races, through: :placements

  validates :name,
            presence: true

  scope :adults, -> { where('born_at <= ?', 18.years.ago) }

  validates :born_at,
            presence: true

  validates :image_url,
            allow_blank: true,
            format: { with:
                          URI::DEFAULT_PARSER.make_regexp }

  validate :legal_age?

  private

  def legal_age?
    return unless !born_at.nil? && born_at >= LEGAL_AGE.years.ago

    errors.add(:born_at, "A racer must be at least #{LEGAL_AGE} years old")
  end
end
