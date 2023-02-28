require 'rails_helper'

RSpec.describe Race, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:tournament) }
    it { is_expected.to have_many(:placements).dependent(:destroy) }
    it { is_expected.to have_many(:racers).through(:placements) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:place) }
  end

  context 'when position already taken' do
    let(:race) { create :race }
    let(:racer) { create :racer }
    let(:racer2) { create :racer }

    it 'does not validate' do
      race.placements.create(racer: racer, position: 1)
      race.placements.create(racer: racer2, position: 1)

      expect(race.valid?).to eq(false)
    end

    it 'returns error message' do
      race.placements.create(racer: racer, position: 1)
      race.placements.create(racer: racer2, position: 1)

      race.valid?

      expect(race.errors[:placements].empty?).to be(false)
    end
  end

  context 'when racer is repeated in race' do
    let(:race) { create :race }
    let(:racer) { create :racer }

    it 'does not validate' do
      race.placements.create(racer: racer, position: 1)
      race.placements.create(racer: racer, position: 2)

      expect(race.valid?).to eq(false)
    end

    it 'returns error message' do
      race.placements.create(racer: racer, position: 1)
      race.placements.create(racer: racer, position: 2)

      race.valid?

      expect(race.errors[:placements].empty?).to be(false)
    end
  end
end
