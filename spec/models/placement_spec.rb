require 'rails_helper'

RSpec.describe Placement, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:racer) }
    it { is_expected.to belong_to(:race) }
  end

  describe 'validations' do
    subject { create :placement }

    it { is_expected.to validate_uniqueness_of(:racer_id).scoped_to(:race_id) }
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_numericality_of(:position).only_integer }
    it { is_expected.to validate_uniqueness_of(:position).scoped_to(:race_id) }
  end

  context 'when position is blank' do
    let(:racer) { create(:racer) }
    let(:race) { create(:race) }

    it 'fails to create a placement' do
      empty_position = Placement.new(racer:, race:)

      expect(empty_position).not_to be_valid
      expect(empty_position.errors[:position]).to include("can't be blank")
    end
  end

  describe '.get_placements scope' do
    let!(:race) { create(:race, date: Date.current, place: 'RSpec Race') }
    let!(:racer1) { create(:racer, name: 'Racer 1', born_at: 20.years.ago) }
    let!(:racer2) { create(:racer, name: 'Racer 2', born_at: 20.years.ago) }
    let!(:placement1) { create(:placement, racer: racer1, race:, position: 1) }
    let!(:placement2) { create(:placement, racer: racer2, race:, position: 2) }
    let(:expected_output) do
      [
        Placement.find(1),
        Placement.find(2)
      ]
    end

    it 'returns placements in order by race id and racer position' do
      expect(Placement.get_placements).to eq(expected_output)
    end
  end
end
