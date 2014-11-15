foobars = require '../src/app.coffee'
app = require('express')()

app.set 'view engine', 'html'
app.engine 'html', foobars.parse

app.get '/', (req, res)->
  res.render 'home',
    me:'Joe'
    friends:[
      {name:'Jonnie',age:18,siblings:[]},
      {name:'Matt',age:18,siblings:[
        {name:'Georgie', age:14}
      ]}
    ]
app.listen 1337


