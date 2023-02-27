class Tournament < ApplicationRecord
  has_many :races, dependent: :destroy

  validates :name, presence: true
end
