exports.parse = (src, helpers, cb)->
  reval = (helpers, value)->new Function('return '+value).bind(helpers)()
  entities = new(require('html-entities').AllHtmlEntities)()
  $ = require('cheerio').load entities.decode require('fs').readFileSync src, 'utf8'
  replaceData = (src, templateData, value)->
    $(src.match(/{{[^>#](.*?)}}/g)).map ->
      src = src.replace this, reval(templateData, this.replace /[{}]/g, '')
    $(value).before src
  $('show').map (index, value)->
    replaceData $('template[name='+$(value).attr('name')+']').html(), helpers, value
  $('if').map (index, value)->
    if reval helpers, entities.decode $.html(value).split('<if ')[1].split('>')[0].replace(/["]/g,'')
      replaceData $(value).html(), helpers, value
  $('each').map (index, value)->
    reval(helpers, entities.decode $(value).attr('of')).map (index, data)->
      replaceData $(value).html(), data, value
  $('markdown').map (index, value)->
    $(value).before(require('node-markdown').Markdown($(value).html()))
  $('show, each, if, template, markdown').remove()
  cb(null, $.html().replace /[\n]/g,'')||$.html().replace /[\n]/g,''
