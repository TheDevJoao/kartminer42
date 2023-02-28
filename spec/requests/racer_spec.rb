require 'rails_helper'

RSpec.describe 'Racers', type: :request do
  let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }

  describe 'GET /racers' do
    context 'when a racer exists' do
      let(:racer) { build_stubbed(:racer) }
      let(:expected_response) do
        [
          {
            id: racer.id,
            name: racer.name,
            born_at: racer.born_at.strftime('%d/%m/%Y'),
            image_url: racer.image_url
          }
        ]
      end

      before { allow(Racer).to receive(:all).and_return([racer]) }

      it 'returns an ok status code' do
        get '/racers', headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a racer in JSON format' do
        get '/racers', headers: { 'Accept' => 'application/json' }

        expect(parsed_body).to eq(expected_response)
      end
    end

    context 'when no racers exist' do
      it 'returns an ok status code' do
        get '/racers', headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty response' do
        get '/racers', headers: { 'Accept' => 'application/json' }

        expect(parsed_body).to eq([])
      end
    end
  end

  describe 'GET /racers/:id' do
    context 'when a racer exists' do
      let(:racer) { build_stubbed(:racer) }
      let(:expected_response) do
        {
          id: racer.id,
          name: racer.name,
          born_at: racer.born_at.strftime('%d/%m/%Y'),
          image_url: racer.image_url
        }
      end

      before { allow(Racer).to receive(:find).with(racer.id.to_s).and_return(racer) }

      it 'returns an ok status code' do
        get "/racers/#{racer.id}", headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a racer in JSON format' do
        get "/racers/#{racer.id}", headers: { 'Accept' => 'application/json' }

        expect(parsed_body).to eq(expected_response)
      end
    end

    context 'when no racers exist' do
      let(:racer) { nil }
      let(:expected_response) do
        {
          error: 'Racer not found'
        }
      end

      before { allow(Racer).to receive(:find).with('1').and_raise(ActiveRecord::RecordNotFound) }

      it 'returns HTTP status not found' do
        get '/racers/1', headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /racers' do
    context 'when parameters are valid' do
      let(:valid_params) do
        {
          id: 1,
          name: 'John Doe',
          born_at: '24/03/1994',
          image_url: 'https://www.test.com/image.png'
        }
      end

      it 'returns an ok status code' do
        post '/racers', params: { racer: valid_params }, headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a created racer' do
        post '/racers', params: { racer: valid_params }, headers: { 'Accept' => 'application/json' }

        expect(parsed_body).to eq(valid_params)
      end
    end

    context 'when parameters are invalid' do
      let(:invalid_params) do
        {
          id: 1,
          name: 'John Doe',
          born_at: '24/03/2022',
          image_url: 'https://www.test.com/image.png'
        }
      end

      it 'returns HTTP status unprocessable entity' do
        post '/racers', params: { racer: invalid_params }, headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        post '/racers', params: { racer: invalid_params }, headers: { 'Accept' => 'application/json' }

        expect(parsed_body[:born_at])
          .to include("A racer must be at least #{Racer::LEGAL_AGE} years old")
      end
    end

    context 'when name is blank' do
      let(:invalid_params) do
        {
          born_at: '24/03/1994',
          image_url: 'https://www.test.com/image.png'
        }
      end

      it 'returns HTTP status unprocessable entity' do
        post '/racers', params: { racer: invalid_params }, headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        post '/racers', params: { racer: invalid_params }, headers: { 'Accept' => 'application/json' }

        expect(parsed_body[:name]).to include("can't be blank")
      end
    end
  end

  describe 'PATCH /racers/:id' do
    context 'when parameters are valid' do
      let(:racer) { create(:racer) }
      let(:valid_params) do
        {
          name: racer.name,
          born_at: racer.born_at.strftime('%d/%m/%Y'),
          image_url: racer.image_url
        }
      end

      it 'returns an ok status code' do
        patch "/racers/#{racer.id}", params: { racer: valid_params }, headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns an updated racer' do
        patch "/racers/#{racer.id}", params: { racer: valid_params }, headers: { 'Accept' => 'application/json' }

        expect(parsed_body).to include(valid_params)
      end
    end

    context 'when parameters are invalid' do
      let(:racer) { create(:racer, :with_inappropriate_age) }

      it 'raises ActiveRecord::RecordInvalid exception' do
        expect { racer.save! }.to raise_error(ActiveRecord::RecordInvalid,
                                              'Validation failed: Born at A racer must be at least 18 years old')
      end
    end
  end

  describe 'DELETE /racers/:id' do
    context 'when racer exists' do
      let(:racer) { create(:racer) }
      let(:race) { create(:race, racer: race) }

      it 'returns an ok status code' do
        delete "/racers/#{racer.id}", headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when racer does not exist' do
      before { allow(Racer).to receive(:find).with('99').and_raise(ActiveRecord::RecordNotFound) }

      it 'returns HTTP status not found' do
        delete '/racers/99', params: { id: 99 }, headers: { 'Accept' => 'application/json' }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
