class ApplicationController < ActionController::API
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def welcome
    render json: {'status' => 'ok', 'message' => 'You are in Booking Sync API'}.to_json
  end

  def not_found(error)
    render json: {'status' => 'error', 'message' => error.exception}.to_json, status: :not_found
  end

  private

  def authenticate
    unless request.headers["auth-token"] == Rails.application.secrets.api_key
      render json: {'status' => 'error', 'message' => 'You are not authorized'}.to_json, status: :unauthorized
      return
    end
  end
end
