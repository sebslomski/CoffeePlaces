class exports.LoginView extends Backbone.View
  id: 'splash-screen-view'

  render: ->
    $(@el).html(require('./templates/splash_screen'))
    $('body').html(@el)

    cl = new CanvasLoader('splash-screen-loader')
    cl.setDiameter(150)
    cl.setDensity(14)
    cl.setSpeed(1)
    cl.setFPS(15)
    cl.setShape('roundRect')
    cl.show()
