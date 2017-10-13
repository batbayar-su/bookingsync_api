class Rental < ApplicationRecord
  has_many :bookings

  validates_presence_of :name, :daily_rate
end
