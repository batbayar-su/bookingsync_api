class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.string :client_email
      t.integer :rental_id
      t.date :start_at
      t.date :end_at
      t.float :price

      t.timestamps
    end

    add_index :bookings, :rental_id
  end
end
