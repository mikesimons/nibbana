jq = require( 'jquery' )

# A hack to allow CORS to work under NodeJS.
module.exports = ->
  mod = "xmlhttprequest"
  XMLHttpRequest = require( mod ).XMLHttpRequest;
  jq.support.cors = true;
  jq.ajaxSettings.xhr = () -> return new XMLHttpRequest;