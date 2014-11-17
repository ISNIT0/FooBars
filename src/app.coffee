exports.parse = (src, data, cb)->
  $ = require('cheerio').load require('fs').readFileSync src, 'utf8'
  getData = (value)->
    if $(value).is('html') then return data
    else return (new Function('return '+($(value).attr('data')||'this'))).bind(getData($(value).parent()))()
  replaceData = (index, value)->
    $(value).children('temp, data').map (index, value)->{
         'temp':(->each(0, value)),'data':->$(value).html getData value
      }[value.name]()
    $(value).children().not('temp').map replaceData
  each=(index, value)->
    getData(value).map (data, index)->replaceData $(value).before $('<div>').attr('data',$(value).attr('data')+'['+index+']').html($(value).html())
  replaceData(0,$('body')[0])
  $('temp').remove()
  cb(null, $.html())
