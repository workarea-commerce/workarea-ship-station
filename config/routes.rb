Workarea::Storefront::Engine.routes.draw do
  post :ship_station_webhook, as: :ship_station_webhook, controller: 'ship_station_webhook', action: 'event'
end

Workarea::Admin::Engine.routes.draw do
  resources :orders, only: [] do
    member do
      get :hold_date
      patch :save_hold_date
      patch :clear_hold_date
    end
  end
end
