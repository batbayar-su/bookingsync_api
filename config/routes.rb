Rails.application.routes.draw do
  root to: "application#welcome"
  namespace :api do
    namespace :v1 do
      resources :rentals do
        resources :bookings
      end
    end
  end
  # match '*a', :to => 'application#not_found', via: :get
end
