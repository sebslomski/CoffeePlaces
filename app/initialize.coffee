{BrunchApplication} = require 'helpers'
{MainRouter} = require 'routers/main_router'
{SplashScreenView} = require 'views/splash_screen'
{MainView} = require 'views/main'

class exports.Application extends BrunchApplication
  # This callback would be executed on document ready event.
  # If you have a big application, perhaps it's a good idea to
  # group things by their type e.g. `@views = {}; @views.home = new HomeView`.
  initialize: ->
    @router = new MainRouter
    @views =
      SplashScreen: new SplashScreenView
      Main: new MainView

window.app = new exports.Application

window.init = ->
  venues = [{
    "name": "Café am Nordbad",
    "address": "Schleißheimer Straße 142a  München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "Coffee Fellows",
    "address": "Leopoldstr. 70, 80802 München",
    "tags": {
      "wifi": "2.5€/h, 6€/d, 20€/w, 35€/m"
    }
  },{
    "name": "San Francisco Coffee Company im Tal",
    "address": "Im Tal, 80331 München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company am Odeonsplatz",
    "address": "Theatinerstr. 23, 80331 München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Leopoldstraße",
    "address": "Leopoldstraße, München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company am Platzl",
    "address": "Am Platzl 3, 80331 München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Lehel",
    "address": "Liebigstrasse 10a, 80538 München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Haidhausen",
    "address": "Innere Wiener Strasse 57, 81667 München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Neuhausen",
    "address": "Nymphenburger Strasse 151, 80636 München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Gärtnerplatz",
    "address": "Gärtnerplatz 2, 80469 München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Kurfürstenplatz",
    "address": "Hohenzollernstrasse 84, München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Rotkreuzplatz",
    "address": "Nymphenburger Str. 151, München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Riem Arcaden",
    "address": "Riem Arcaden, München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Pasing",
    "address": "Pasinger Bahnhofsplatz 4, 81241 München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Arabellapark",
    "address": "Arabellastrasse 17 - 19, 81925 München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Flughafen",
    "address": "Terminal 2, München",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "San Francisco Coffee Company Starnberg",
    "address": "Wittelsbacher Strasse 9, 82319 Starnberg",
    "tags": {
      "wifi": "free"
    }
  },{
    "name": "Trachtenvogl",
    "address": "Reichenbachstraße 47, 80469 München"
  }]


  return [(venue, cb) ->
    geocoder = new google.maps.Geocoder()
    geocoder.geocode(address: venue.address, (results, status) =>
      if status is google.maps.GeocoderStatus.OK
        location = results[0].geometry.location
        venue.location =
          lat: location.Sa
          lng: location.Ta
          address: venue.address
        delete venue.address
        cb(venue)
      else
        console.log(status)
    )
  , venues, (e) ->
    Venue = require('models/venue').VenueModel
    x = new Venue(e)
    x.save()
    console.log 'done'
  ]
