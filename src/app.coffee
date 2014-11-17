exports.parse = (src, data, cb)->
  entities = new(require('html-entities').AllHtmlEntities)()
  $ = require('cheerio').load entities.decode require('fs').readFileSync src, 'utf8'
  reval = (element)->if $(element)[0].name!='body' then (new Function('return '+getExpression element)).
  bind(reval $(element).parent()[0])() else data
  getExpression = (element)->(entities.decode($.html(element)).match(/{.*?}/)||[''])[0].
  replace(/[{}"]/g,'')
  temp = (element)-> $({'[object Boolean]':(->[].constructor.apply(null, [+reval element])),'[object Array]':->reval element
  }[Object.prototype.toString.call reval element]()).map (index, data)->
    $(element).before $('<div {('+(getExpression element)+')['+index+']} >').html($(element).html())
  replaceData = (index, value)->
    $(value).children('temp, data').map (index, value)->{'temp':(->temp value),'data':->
      $(value).html (reval value).toString()}[value.name]()
    $(value).children().not('temp').map replaceData
  replaceData 0,$('body')[0]
  $('temp').remove()
  cb(null, entities.decode $.html())
