Entities = require('html-entities').AllHtmlEntities
entities = new Entities()
cheerio = require 'cheerio'

helpers =
  test:['billy','fred']
  a:->'a'
  b:->'b'

parse = (src, helpers)->
  replaceData = (src, templateData)->
    src.match(/{{[^>#](.*?)}}/g).map (value, index)->
      src.replace value, new Function(
        'return '+value.replace /[{}]/g, ''
      ).bind(templateData)()
    .join('')
  file = require('fs').readFileSync src, 'utf8'
  out = entities.decode file
  $ = cheerio.load out
  $('show').map (index, value)->
    $(value).before $('template[name='+$(value).attr('name')+']').html()
    $(value).remove()
    $('template[name='+$(value).attr('name')+']').remove()
  $('if').map (index, value)->
    if !new Function('return '+
      entities.decode $.html(value).split('<if ')[1]
      .split('>')[0]
      .replace(/["]/g,'')
    ).bind(helpers)()
      $(value).remove()
    else
      $(value).before $(value).html()
      $(value).remove()
  $('each').map (index, value)->
    $(value).before (new Function('return '+entities.decode $(value).attr('of'))
      .bind(helpers)()||[]).map (data, index)->
        replaceData($(value).html(), data)
    $(value).remove()
  $.html().replace /[\n]/g,''

console.log parse './temp.bars', helpers
