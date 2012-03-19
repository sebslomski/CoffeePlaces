VenueDetailInfoTemplate = require('./templates/venue_detail_info')
{VenueModel} = require('models/venue')

class exports.VenueDetailView extends Backbone.View
  id: '#aside-popup'

  constructor: (id) ->
    @model = new VenueModel(id)

  render: ->
    $(@el).addClass('slideIn')
    $('#aside-popup .content').html(VenueDetailInfoTemplate(venue: model))
