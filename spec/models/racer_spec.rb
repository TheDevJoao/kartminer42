require 'rails_helper'

RSpec.describe Racer, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:placements) }
    it { is_expected.to have_many(:races).through(:placements) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:born_at) }

    context 'when racer is under the legal age' do
      subject { build(:racer, :with_inappropriate_age) }

      it { is_expected.to be_invalid }

      it 'shows an error' do
        subject.valid?
        expect(subject.errors[:born_at])
          .to include("A racer must be at least #{Racer::LEGAL_AGE} years old")
      end
    end

    context 'when image_url is valid' do
      subject { build(:racer, :valid_url) }
      it { is_expected.to be_valid }
    end

    context 'when image_url is invalid' do
      subject { build(:racer, :invalid_url) }
      it { is_expected.not_to be_valid }
    end

    context 'when image_url is blank' do
      it { is_expected.to allow_value('', nil).for(:image_url) }
    end
  end
end
