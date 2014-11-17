foobars = require '../src/app.coffee'
app = require('express')()

app.set 'view engine', 'html'
app.engine 'html', foobars.parse

app.get '/', (req, res)->
  res.render 'home',
    test:[['Joe','Jack'],['Billy','Freddie']]
app.listen 1337


