# app/requests/bookings_spec.rb
require 'rails_helper'

RSpec.describe 'Bookings API' do
  # Initialize the test data
  let!(:rental) { create(:rental) }
  let!(:booking) { create(:booking, rental_id: rental.id) }
  let(:rental_id) { rental.id }
  let(:id) { booking.id }

  # Test suite for GET /rentals/:rental_id/bookings
  describe 'GET /rentals/:rental_id/bookings' do
    before { get "/api/v1/rentals/#{rental_id}/bookings", headers: {'auth-token' => 'a1B2c3D4e5F6'} }

    context 'when rental exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all rental bookings' do
        expect(json.size).to eq(1)
      end
    end

    context 'when rental does not exist' do
      let(:rental_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match('Couldn\'t find Rental with \'id\'=0')
      end
    end
  end

  # Test suite for GET /rentals/:rental_id/bookings/:id
  describe 'GET /rentals/:rental_id/bookings/:id' do
    before { get "/api/v1/rentals/#{rental_id}/bookings/#{id}", headers: {'auth-token' => 'a1B2c3D4e5F6'} }

    context 'when rental booking exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the booking' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when rental booking does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match('Couldn\'t find Booking with \'id\'=0')
      end
    end
  end

  # Test suite for POST /rentals/:rental_id/bookings
  describe 'POST /rentals/:rental_id/bookings' do
    let(:valid_attributes) { { client_email: Faker::Internet.email, start_at: (booking.end_at + 1), end_at: (booking.end_at + 6) } }

    context 'when request attributes are valid' do
      before { post "/api/v1/rentals/#{rental_id}/bookings", params: valid_attributes, headers: {'auth-token' => 'a1B2c3D4e5F6'} }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns created booking' do
        expect(json['price']).to eq(rental.daily_rate * 5)
      end
    end

    context 'when an invalid request' do
      before { post "/api/v1/rentals/#{rental_id}/bookings", params: {}, headers: {'auth-token' => 'a1B2c3D4e5F6'} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(json['client_email'])
          .to include('can\'t be blank')
        expect(json['start_at'])
          .to include('can\'t be blank')
        expect(json['end_at'])
          .to include('can\'t be blank')
      end
    end
  end

  # # Test suite for PUT /rentals/:rental_id/bookings/:id
  # describe 'PUT /rentals/:rental_id/bookings/:id' do
  #   let(:valid_attributes) { { name: 'Mozart' } }

  #   before { put "/api/v1/rentals/#{rental_id}/bookings/#{id}", params: valid_attributes, headers: {'auth-token' => 'a1B2c3D4e5F6'} }

  #   context 'when booking exists' do
  #     it 'returns status code 204' do
  #       expect(response).to have_http_status(204)
  #     end

  #     it 'updates the booking' do
  #       updated_booking = booking.find(id)
  #       expect(updated_booking.name).to match(/Mozart/)
  #     end
  #   end

  #   context 'when the booking does not exist' do
  #     let(:id) { 0 }

  #     it 'returns status code 404' do
  #       expect(response).to have_http_status(404)
  #     end

  #     it 'returns a not found message' do
  #       expect(response.body).to match(/Couldn't find booking/)
  #     end
  #   end
  # end

  # # Test suite for DELETE /rentals/:id
  # describe 'DELETE /rentals/:id' do
  #   before { delete "/api/v1/rentals/#{rental_id}/bookings/#{id}", headers: {'auth-token' => 'a1B2c3D4e5F6'} }

  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
end