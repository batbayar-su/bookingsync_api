class Booking < ApplicationRecord
  belongs_to :rental

  validates_presence_of :client_email, :rental_id, :start_at, :end_at

  before_create :set_price

  private

  def set_price
    self.price = (self.end_at - self.start_at) * self.rental.daily_rate
  end
end
