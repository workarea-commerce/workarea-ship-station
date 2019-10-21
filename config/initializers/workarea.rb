Workarea.configure do |config|
  config.ship_station = ActiveSupport::Configurable::Configuration.new
  config.ship_station.api_timeout = 10
  config.ship_station.open_timeout = 10

  # setting this config value will set a ship_by_date for new orders.
  # This value will be added to the current date and sent in the ship_by_date field.
  #
  # This value must be an integer.
  config.ship_station.ship_by_date_lead_days = nil
end
