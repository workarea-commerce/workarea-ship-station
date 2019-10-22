Workarea Ship Station
================================================================================

ShipStation plugin for the Workarea platform.

Overview
--------------------------------------------------------------------------------

ShipStation integration for the Workarea Commerce Platform. This plugin handles
sending orders via the ShipStation API as well as receiving fulfillment updates
from webhooks.

This integration supports the following features:

  * API integration to send orders to from Workarea to ShipStation
  * Webhook endpoints to receive fulfillment data from ShipStation
  * Administration controls for setting and removing on hold status
  * Configuration options for ship by date

Workarea admins with access to the orders screen will have the option to set an order on hold until a specified date.
An admin can set a specific hold untill date as well as release orders from on hold that have been placed on hold from the Workarea admin.


Configuration
--------------------------------------------------------------------------------

ShipStation API credentials are required to send orders and receive fulfillments.
You can get your API credentials by logging into your ShipStation account and going
to settings, then clicking "API settings" under the "Account" tab.

Generate API keys if there are none present and add them to your host apps secrets file:

```
  ship_station:
    api_key: YOUR-API-KEY
    api_secret: YOUR-API-SECRET
```

**Fulfillment Notification**

Workarea receives fulfillment notifications via ShipStation webhooks.

Documentation on setting up ShipStation Webhooks can be found [here](https://help.shipstation.com/hc/en-us/articles/360025856252-ShipStation-Webhooks#UUID-1a4971f4-8fb5-f4a5-c399-f36cff610435_UUID-9336531a-ef72-7c0f-6fbb-598f8f144cf3)

When setting up your integration in ShipStation set the following values:

  * Name Description: Can be anything you want, for example "Workarea Fulfillment notification"
  * Select "On Items Shipped" from the drop down.
  * Select "All Stores" from the second dropdown.
  * Send Url: Put "https://YOURDOMAINHERE/ship_station_webhook" - Be sure to change replace YOURDOMAINHERE with your actual domain.

Workarea supports the "On Items Shipped" action only.

**Be sure to create a webhook for each domain your Workarea app supports if you have a multisite setup**

You can add an optional ship by date lead time via a configuration value.
This value will be added to the current date and sent to ShipStation when an order is placed. This date will show as the "Ship By" date in the orders admin screen in ShipStation.

```ruby
  config.ship_station.ship_by_date_lead_days = 5
```


Getting Started
--------------------------------------------------------------------------------

This gem contains a Rails engine that must be mounted onto a host Rails application.

Then add the gem to your application's Gemfile specifying the source:

    # ...
    gem 'workarea-ship_station'
    # ...

Update your application's bundle.

    cd path/to/application
    bundle


Workarea Platform Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea platform documentation.

License
--------------------------------------------------------------------------------

Workarea Ship Station is released under the [Business Software License](LICENSE)
