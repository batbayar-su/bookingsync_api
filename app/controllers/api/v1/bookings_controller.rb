class Api::V1::BookingsController < ApplicationController
  before_action :set_rental
  before_action :set_rental_booking, only: [:show, :update, :destroy]

  # GET /bookings
  def index
    render json: @rental.bookings
  end

  # GET /bookings/1
  def show
    render json: @booking
  end

  # POST /bookings
  def create
    @booking = @rental.bookings.new(booking_params)

    if @booking.save
      render json: @booking, status: :created
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookings/1
  def update
    if @booking.update(booking_params)
      render json: @booking
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy
    render json: {'status' => 'ok', 'message' => 'Rental deletion succeed'}.to_json
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rental
    @rental = Rental.find(params[:rental_id])
  end
  def set_rental_booking
    @booking = @rental.bookings.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def booking_params
    params.permit(:client_email, :start_at, :end_at)
  end
end
