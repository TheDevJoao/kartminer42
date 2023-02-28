require 'rails_helper'

RSpec.describe 'Races', type: :request do
  let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }

  describe 'GET /races' do
    context 'when no races exist' do
      it 'returns an ok status code' do
        get '/races', headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty response' do
        get '/races', headers: { 'Accept' => 'application/json' }

        expect(parsed_body).to eq([])
      end
    end

    context 'when a race exists with placements' do
      let(:placements) do
        [
          build(:placement, position: 1, race: nil),
          build(:placement, position: 2, race: nil)
        ]
      end
      let!(:race) { create(:race, placements:) }
      let(:expected_response) do
        [
          {
            id: race.id,
            tournament_id: race.tournament.id,
            place: race.place,
            date: race.date.strftime('%d/%m/%Y'),
            placements: race.placements.order(:position).map do |placement|
              {
                id: placement.id,
                racer_id: placement.racer_id,
                position: placement.position
              }
            end
          }
        ]
      end

      before { allow(Race).to receive(:all).and_return([race]) }

      it 'returns an ok status code' do
        get '/races', headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a race in JSON format' do
        get '/races', headers: { 'Accept' => 'application/json' }

        expect(parsed_body).to eq(expected_response)
      end
    end

    context 'when multiple races exist with placements' do
      let(:placements) do
        [
          build(:placement, position: 1, race: nil),
          build(:placement, position: 2, race: nil)
        ]
      end

      let!(:races) { create_list(:race, 3, placements:) }

      let(:expected_response) do
        races.map do |race|
          {
            id: race.id,
            tournament_id: race.tournament.id,
            place: race.place,
            date: race.date.strftime('%d/%m/%Y'),
            placements: race.placements.order(:position).map do |placement|
              {
                id: placement.id,
                racer_id: placement.racer_id,
                position: placement.position
              }
            end
          }
        end
      end

      it 'returns an ok status code' do
        get '/races', headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns races in JSON format' do
        get '/races', headers: { 'Accept' => 'application/json' }

        expect(parsed_body).to eq(expected_response)
      end
    end

    context 'when a race exists with no placements' do
      let!(:race) { create(:race) }
      let(:expected_response) do
        [
          {
            id: race.id,
            tournament_id: race.tournament.id,
            place: race.place,
            date: race.date.strftime('%d/%m/%Y'),
            placements: []
          }
        ]
      end

      before { allow(Race).to receive(:all).and_return([race]) }

      it 'returns an ok status code' do
        get '/races', headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a race in JSON format' do
        get '/races', headers: { 'Accept' => 'application/json' }

        expect(parsed_body).to eq(expected_response)
      end
    end
  end
end
