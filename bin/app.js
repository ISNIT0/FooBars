// Generated by CoffeeScript 1.8.0
(function() {
  exports.parse = function(src, helpers, cb) {
    var $, entities, replaceData, reval;
    reval = function(helpers, value) {
      return new Function('return ' + value).bind(helpers)();
    };
    entities = new (require('html-entities').AllHtmlEntities)();
    $ = require('cheerio').load(entities.decode(require('fs').readFileSync(src, 'utf8')));
    replaceData = function(src, templateData, value) {
      $(src.match(/{{[^>#](.*?)}}/g)).map(function() {
        return src = src.replace(this, reval(templateData, this.replace(/[{}]/g, '')));
      });
      return $(value).before(src);
    };
    $('show').map(function(index, value) {
      return replaceData($('template[name=' + $(value).attr('name') + ']').html(), helpers, value);
    });
    $('if').map(function(index, value) {
      if (reval(helpers, entities.decode($.html(value).split('<if ')[1].split('>')[0].replace(/["]/g, '')))) {
        return replaceData($(value).html(), helpers, value);
      }
    });
    $('each').map(function(index, value) {
      return reval(helpers, entities.decode($(value).attr('of'))).map(function(index, data) {
        return replaceData($(value).html(), data, value);
      });
    });
    $('markdown').map(function(index, value) {
      return $(value).before(require('node-markdown').Markdown($(value).html()));
    });
    $('show, each, if, template, markdown').remove();
    return cb(null, $.html().replace(/[\n]/g, '')) || $.html().replace(/[\n]/g, '');
  };

}).call(this);
