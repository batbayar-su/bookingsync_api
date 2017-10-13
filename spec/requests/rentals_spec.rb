# spec/requests/rentals_spec.rb
require 'rails_helper'

RSpec.describe 'Rentals API', type: :request do
  # initialize test data
  let!(:rentals) { create_list(:rental, 10) }
  let(:rental_id) { rentals.first.id }

  # Test suite for GET /api/v1/rentals
  describe 'GET /api/v1/rentals' do
    # make HTTP get request before each example
    before { get '/api/v1/rentals', headers: {'auth-token' => 'a1B2c3D4e5F6'} }

    it 'returns rentals' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /api/v1/rentals/:id
  describe 'GET /api/v1/rentals/:id' do
    before { get "/api/v1/rentals/#{rental_id}", headers: {'auth-token' => 'a1B2c3D4e5F6'} }

    context 'when the record exists' do
      it 'returns the rental' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(rental_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:rental_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match('Couldn\'t find Rental with \'id\'=100')
      end
    end
  end

  # Test suite for POST /api/v1/rentals
  describe 'POST /api/v1/rentals' do
    context 'when the request is valid' do
      before { post '/api/v1/rentals', params: { name: 'Lorem ipsum', daily_rate: '100' }, headers: {'auth-token' => 'a1B2c3D4e5F6'} }

      it 'creates a rental' do
        expect(json['name']).to eq('Lorem ipsum')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/rentals', params: { name: 'Lorem ipsum' }, headers: {'auth-token' => 'a1B2c3D4e5F6'} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['daily_rate'])
          .to include('can\'t be blank')
      end
    end
  end

  # Test suite for PUT /api/v1/rentals/:id
  describe 'PUT /api/v1/rentals/:id' do
    context 'when the record exists' do
      before { put "/api/v1/rentals/#{rental_id}", params: { name: 'Shopping' } , headers: {'auth-token' => 'a1B2c3D4e5F6'} }

      it 'updates the record' do
        expect(json['name']).to match('Shopping')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /api/v1/rentals/:id
  describe 'DELETE /api/v1/rentals/:id' do
    before { delete "/api/v1/rentals/#{rental_id}", headers: {'auth-token' => 'a1B2c3D4e5F6'} }

    it 'returns the feedback' do
      expect(json['status']).to match('ok')
      expect(json['message']).to match('Rental deletion succeed')
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end