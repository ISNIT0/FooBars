

entities = new(require('html-entities').AllHtmlEntities)()
$ = require('cheerio').load entities.decode require('fs').readFileSync 'temp.html', 'utf8'
replaceData = (src, templateData, value)->
$(entities.decode(src).match(/{{[^>#](.*?)}}/g)).map ->
src = src.replace this, new Function('return '+this.replace /[{}]/g, '').bind(templateData)()
$(value).before src
$('temp').map (index, value)->
test = (new Function 'return '+entities.decode($.html(value)).match(/{.*?}/)[0].replace(/[{}"]/g,''))()
$({'[object Boolean]':(->[].constructor.apply(null, [+test])),'[object Array]':->test}[Object.prototype.toString.call test]())
.map (index, data)->replaceData $(value).html(), data, value
$('temp').remove()
console.log $.html()
