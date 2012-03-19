(function() {
  var TagSchema, Venue, VenueSchema, app, express, mongoose, port;

  express = require('express');

  mongoose = require('mongoose');

  app = express.createServer(express.logger());

  app.configure(function() {
    app.use(express.bodyParser());
    app.use(express.static(__dirname + '/../build'));
    return app.use(app.router);
  });

  mongoose.connect('mongodb://read-only:read-only@flame.mongohq.com:27107/coffeeplaces');

  TagSchema = new mongoose.Schema({
    name: {
      type: String,
      required: true
    },
    value: {
      type: String,
      required: true
    }
  });

  VenueSchema = new mongoose.Schema({
    name: {
      type: String,
      required: true
    },
    location: {
      address: {
        type: String,
        required: true
      },
      lat: {
        type: Number,
        required: true
      },
      lng: {
        type: Number,
        required: true
      }
    },
    tags: [TagSchema],
    created: {
      type: Date,
      "default": Date.now
    }
  });

  Venue = mongoose.model('Venue', VenueSchema);

  app.get('/venues', function(req, res) {
    return Venue.find(function(err, venues) {
      return res.json(venues);
    });
  });

  app.get('/venues/by-name/:name', function(req, res) {
    return Venue.find().$where({
      $or: [
        {
          name: {
            $regex: new RegExp(req.params.name, 'i')
          },
          address: {
            $regex: new RegExp(req.params.name, 'i')
          }
        }
      ]
    }).run(function(err, venues) {
      return res.json(venues);
    });
  });

  app.get('/venues/in-bounds', function(req, res) {
    return Venue.where('location.lat').$lt(req.query.latN).$gt(req.query.latS).where('location.lng').$lt(req.query.lngE).$gt(req.query.lngW).run(function(err, venues) {
      return res.json(venues);
    });
  });

  app.post('/venue', function(req, res) {
    new Venue(req.body).save();
    return res.send('done');
  });

  port = process.env.PORT || 3000;

  app.listen(port, function() {
    return console.log('Listening on ' + port);
  });

}).call(this);
