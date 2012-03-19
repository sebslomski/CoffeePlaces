class exports.VenueModel extends Backbone.Model
  url: '/venue'

  parse: (res) ->
    res['id'] = res['_id']
    delete res['_id']
    return res

  getLocation: () ->
    return new google.maps.LatLng(@get('location').lat, @get('location').lng)
