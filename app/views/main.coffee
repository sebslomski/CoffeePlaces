{VenueStore} = require('collections/venue_store')
VenueListTemplate = require('./templates/venue_list_item')
VenueDetailInfoTemplate = require('./templates/venue_detail_info')

class exports.MainView extends Backbone.View
  id: 'main-view'

  events:
    'keyup #search': 'search'
    'click #aside-popup-close': 'hideInfo'
    'click #venue-list li': 'showDetailInfo'


  showDetailInfo: (e) ->
    venueId = $(e.target).attr('id').split('-')[1]
    window.location.hash = "/venue/#{venueId}"
    return
    $('#aside-popup').addClass('slideIn')
    venue = @collection.get(venueId)
    $('#aside-popup .content').html(VenueDetailInfoTemplate(model: venue))


  hideInfo: (e) ->
    $('#aside-popup').removeClass('slideIn')


  initMap: ->
    mapOptions =
      zoom: 15
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @map = new google.maps.Map($('#map').get(0), mapOptions)
    @markers ?= {}

    google.maps.event.addListener(@map, 'idle', () =>

      if not @ignoreNextIdleEvent
        @ignoreNextIdleEvent = true
        done = () => @ignoreNextIdleEvent = false

        if not @map.getBounds()?
          done()
          return

        latLngNE = @map.getBounds().getNorthEast()
        latLngSW = @map.getBounds().getSouthWest()

        @collection.bounds =
          latN: latLngNE.lat()
          latS: latLngSW.lat()
          lngE: latLngNE.lng()
          lngW: latLngSW.lng()


        error = () =>
          @collection.reset()
          done()

        success = () =>
          for id of @markers
            if not @collection.get(id)
              @markers[id].setMap(null)
              delete @markers[id]

          for model in @collection.models
            if model.id not in _.keys(@markers)
              @markers[model.id] = new google.maps.Marker(
                position: model.getLocation()
                title: model.get('name')
                map: @map
              )
              google.maps.event.addListener(@markers[model.id], 'click', (e) =>
                window.location.hash = "/venue/#{model.id}"
              )
          done()

        @collection.fetch(
          success: success
          error: error
        )
    )


  centerMap: ->
    if not @ignoreNextSearch
      @ignoreNextSearch = true
      geocoder = new google.maps.Geocoder()
      geocoder.geocode(address: $('#search').val(), (results, status) =>
        if status is google.maps.GeocoderStatus.OK
          @map.setCenter(results[0].geometry.location)
          @ignoreNextSearch = false
      )



  render: ->
    if not @collection?
      @collection = new VenueStore()
      @collection.on('all', @renderVenues)

    $(@el).html(require('./templates/main'))
    $('body').html(@el)

    @initMap()

    $('#search').val('München').trigger('keyup')


  search: (e) ->
    val = $('#search').val()
    if not @lastFilter? or @lastFilter != val
      @lastFilter = val
      @centerMap()


  renderVenues: =>
    htmlList = ""
    for model in @collection.models
      htmlList += VenueListTemplate(model: model)

    $(@el).find('#venue-list').html(htmlList)
