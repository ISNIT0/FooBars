Entities = require('html-entities').AllHtmlEntities
entities = new Entities()
cheerio = require 'cheerio'
fs = require 'fs'

data =
  name:'Geoff'
  age:18
  friends:['freddie','billy']

helpers =
  isTrue:->true

fs.readFile './temp.bars', 'utf8', (err, file)->

  out = entities.decode file
  $ = cheerio.load out

  (entities.decode($.html()).match(/{{> (.*?)}}/g)||[]).map (bar, index)->
    out = entities.decode out.replace bar, $('template[name='+bar.replace(/[{}>#]/g,'')+']').html()||'You are missing a template!'
    out = entities.decode out.replace $('template[name='+bar.replace(/[{}>#]/g,'')+']'),''

  $ = cheerio.load out

  $('each').map (index, bar)->
    thisBar=''
    (data[bar.attribs.of]||[]).map (val, index)->
      thisBar+=replaceData $(bar).html(), 'this', val
    out = entities.decode out.replace $.html(bar), thisBar

  $ = cheerio.load out

  $('if').map (index, bar)->
    thisBar=''
    Object.keys(bar.attribs).map (val,index)->
      if eval(val)==helpers[bar.attribs[val]]() || val==helpers[bar.attribs[val]]() then thisBar+=$(bar).html()
    out = out.replace $.html(bar), thisBar

  $ = cheerio.load out

  (entities.decode($.html()).match(/\{{([^>#}]+)\}}/g)||[]).map (bar, index)->
    Object.keys(data).map (key, index)->
      if key == bar.replace /[{}]/g,'' then out = out.replace bar, data[key]



  $ = cheerio.load out
  $('template').remove()
  out = $.html()

  console.log out


replaceData = (src,key,data)->entities.decode(src).replace('{{'+key+'}}', data)
