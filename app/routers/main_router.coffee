class exports.MainRouter extends Backbone.Router
  routes :
    'loading': 'loading'
    'main': 'main'
    'login': 'login'
    'venue/:id': 'venueDetail'

  loading: ->
    app.views.SplashScreen.render()

  main: ->
    app.views.Main.render()

  venueDetail: ->
    if not $('#map').length
      @main()
    app.views.VenueDetail.render()


  login: ->
    app.view.Login.render()
