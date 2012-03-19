express = require('express')
mongoose = require('mongoose')


app = express.createServer(express.logger())
app.configure(->
  app.use(express.bodyParser())
  app.use(express.static(__dirname + '/../build'))
  app.use(app.router)
)
mongoose.connect('mongodb://read-only:read-only@flame.mongohq.com:27107/coffeeplaces')



TagSchema = new mongoose.Schema(
  name: {type: String, required: true}
  value: {type: String, required: true}
)

VenueSchema = new mongoose.Schema(
  name: {type: String, required: true}
  location:
    address: {type: String, required: true}
    lat: {type: Number, required: true}
    lng: {type: Number, required: true}
  tags: [TagSchema]
  created: {type: Date, default: Date.now}
)

Venue = mongoose.model('Venue', VenueSchema)




app.get('/venues', (req, res) ->
  Venue.find((err, venues) ->
    res.json(venues)
  )
)

app.get('/venues/by-name/:name', (req, res) ->
  Venue
    .find()
    .$where(
      $or: [
        name:
          $regex: new RegExp(req.params.name, 'i')
        address:
          $regex: new RegExp(req.params.name, 'i')
      ]
    )
    .run((err, venues) ->
      res.json(venues)
    )
)


app.get('/venues/in-bounds', (req, res) ->
  Venue
    .where('location.lat')
      .$lt(req.query.latN)
      .$gt(req.query.latS)
    .where('location.lng')
      .$lt(req.query.lngE)
      .$gt(req.query.lngW)
    .run((err, venues) ->
      res.json(venues)
    )
)

app.post('/venue', (req, res) ->
  new Venue(req.body).save()
  res.send('done')
)

port = process.env.PORT or 3000
app.listen(port, ->
  console.log('Listening on ' + port)
)
