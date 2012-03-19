{VenueModel} = require('models/venue')

class exports.VenueStore extends Backbone.Collection
  model: VenueModel

  url: ->
    params = []

    for key in _.keys(@bounds)
      params.push("#{key}=#{@bounds[key]}")

    "/venues/in-bounds?#{params.join('&')}"
